# mm — Code Coverage

Coverage is a `target` variant, `cov`, alongside `debug`, `opt`, `shared`. Adding it
to the target list compiles and links the compiled languages with their coverage
instrumentation, gives the build its own build-root and install-prefix (so a coverage
build never mixes with a regular one), and enables a `coverage` target that gathers the
data a test run produced and renders it three ways: a terminal summary, a browsable
HTML tree, and an lcov file for the editor.

```
mm --target=cov,shared <suite>      # build + run the tests with instrumentation
mm --target=cov,shared coverage     # merge the data and render the report
```

The two steps use the *same* `--target`, because the report lives under the coverage
build-root and reads the binaries from the coverage prefix.

---

## Back ends

The instrumentation and the reader are chosen from the c++ compiler, in
`make/coverage/model.mm`:

- **`llvm`** (the clang family). Compiles with `-fprofile-instr-generate
  -fcoverage-mapping`. Each instrumented process writes its own `.profraw`; mm exports
  `LLVM_PROFILE_FILE` for the whole build so every test driver deposits one into the
  collection directory with no per-recipe plumbing. The report is produced by
  `llvm-profdata merge` followed by `llvm-cov report` / `show` / `export`. This mode
  records **regions and branches**, not just lines, and resolves templates correctly —
  which is why it is preferred for the heavily-templated C++ in `pyre`.

- **`gcov`** (gcc). Compiles with `--coverage`; the compiler drops `.gcno`/`.gcda`
  sidecars next to the objects. The report is produced by `gcovr`, which discovers
  those pairs beneath the project root and emits HTML and lcov in one pass.

Both back ends converge on **lcov** as the interchange format, so everything
downstream — the HTML renderers and the editor — speaks one language regardless of
compiler.

Fortran (`flang`) is switched to the llvm form to match the clang front ends, so a
mixed C/C++/Fortran binary links against a single coverage runtime. `flang`'s coverage
support trails clang's; if a build rejects the flags, fall back to `--coverage` in
`make/compilers/clang/flang.mm` and read the Fortran with `gcov`/`gcovr`.

---

## What the report covers

The llvm reporter attributes the profiles to a set of binaries, discovered automatically
in the model pass: every shared library installed under the prefix, plus every compiled
test-driver binary registered by the test suites. The drivers matter because a header-only
template library instantiates most of its code into them rather than into any `.so` — the
pyre grid case, where a report built from the shared libraries alone would miss nearly
everything. A `wildcard` keeps only the binaries a given run actually built, so a partial
test run never hands the reporter a missing object.

A project rarely needs to name binaries by hand, but `coverage.objects` remains as an
escape hatch for anything mm cannot find on its own:

```makefile
# in a project's .mm configuration
coverage.objects += $(builder.staging)<path-to-some-other-instrumented-binary>
```

When the same inline or template function is instantiated across many binaries — the
shared library and dozens of drivers — llvm-cov reports "functions have mismatched data"
and skips the conflicting instances. This is expected for a template-heavy suite and does
not corrupt the totals; it is a mild undercount of the skipped functions.

### Header attribution

A test driver includes a library's headers from the install prefix, so without help the
compiler records the *installed* copy's path in the coverage data. That makes gcov's
reporter (rooted at the project) drop the headers, and makes llvm-cov attribute them to the
prefix rather than to the tree you edit. A `cov` build corrects this at compile time: for
each library, mm emits a `-fprofile-prefix-map` (gcc) / `-fcoverage-prefix-map` (clang) that
rewrites the library's installed header directory back to its source directory. The maps are
generated from the library model — one per library — and ordered general-to-specific so the
compilers' last-match-wins rule attributes each header to the correct source tree.

The contribution is wired through `compiler.option.sources` as a `coverage.<language>`
party, added only when `cov` is among the target variants, so a non-coverage build is
untouched. The effect is that header coverage lands on the actual source files, both back
ends agree, and the lcov the editor reads points at the tree you have open.

Two caveats worth keeping in front of you when reading a coverage number:

- It measures **execution, not correctness**. A line that runs but computes the wrong
  value reports as covered.
- For header-only templates it only sees the **instantiations the tests happen to
  create**. A high percentage measures those instantiations, not the API surface.

Where it earns its keep: unreached error paths, unexercised branches, and rank-0/rank-1
edge cases.

---

## Targets

| target            | effect                                                        |
|-------------------|---------------------------------------------------------------|
| `coverage`        | merge the collected data and render summary + HTML + lcov     |
| `coverage.info`   | show the resolved settings (back end, paths, active or not)   |
| `coverage.clean`  | discard the collected data and the rendered report            |

`coverage.clean` matters between measurement runs: the profiles accumulate, so wipe them
before a fresh run to avoid folding a previous run's data into the new report.

---

## Tooling

The reporters are not part of a compiler install and must be present on the `PATH`:

- **llvm back end:** `llvm-profdata`, `llvm-cov` — conda-forge **`llvm-tools`**; Ubuntu
  **`llvm`** (they ship with the LLVM distribution).
- **gcov back end:** `gcovr` — conda-forge **`gcovr`**; Ubuntu **`gcovr`**. `gcov`
  itself ships with `gcc`.

Neither reporter is invoked unless you ask for the `coverage` target, and each fails
with a one-line instruction if its tool is missing.

---

## Editor integration (VS Code)

The lcov file is what the editor reads. Install the **Coverage Gutters** extension
(`ryanluker.vscode-coverage-gutters`) and point it at the lcov file:

```jsonc
// .vscode/settings.json
{
  "coverage-gutters.coverageFileNames": ["lcov.info"],
  "coverage-gutters.coverageBaseDir": "<coverage build-root>/coverage"
}
```

`coverage.info` prints the exact lcov path for the active build. "Watch" then paints
covered/uncovered lines in the gutter and inline. The extension is tool-agnostic — it
neither knows nor cares that mm produced the file.

Because header coverage is attributed back to source (see *Header attribution* above), the
lcov points at the files in your working tree — libraries and their headers alike — so the
gutters light up on the source you actually edit, not on installed copies under the prefix.
