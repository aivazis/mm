# Testing with mm

mm supports two complementary testing models. You can mix them freely across a
project — each test suite picks the model that fits.

1. **Per-file drivers** — the classic mm model: every test file is its own small
   program. Silence is pass; the process exit code is the verdict.
2. **Runners** — the suite delegates to a self-discovering test framework
   (Playwright, Vitest, pytest, Catch2, GoogleTest). mm prepares the environment
   the framework needs and invokes it once; the exit code is the verdict.

A test suite is an asset type. It is declared in `.mm/<suite>` and wired into the
project with `<project>.tests := <suite> …`. The suite's tests live under
`tests/<stem>/`, discovered recursively.

---

## Per-file drivers

Each file under the suite directory whose extension is a registered language
source becomes a test driver. mm runs each one; **silence is pass, any output (or
a non-zero exit) is a failure.**

```makefile
# .mm/timer.lib.tests
timer.lib.tests.stem   := timer.lib
timer.lib.tests.extern := timer.lib
```

**Interpreted drivers** launch as `<interpreter> <file>`:

- `.py` — Python, via `python3`
- `.mjs` — Node, via `node`

**Compiled drivers** are compiled and linked into a binary that is then run; one
binary per source file. C and C++ sources qualify.

### Staged execution (opt-in)

An ES-module (`.mjs`) driver in the source tree cannot resolve packages from a
`node_modules` that lives elsewhere — Node walks up from the driver's own
directory, and mm deliberately keeps `node_modules` out of the source tree (it
lives in the web bundle's staging area). Opt in to *staged* execution and mm
copies the driver into a staging directory under the build tree and links a
`node_modules` in beside it before running:

```makefile
qed.ux.tests.staged        := yes
qed.ux.tests.stage.modules := $(qed.ux.stage.modules)   # the bundle's node_modules
```

---

## Runners

Set `<suite>.runner` and the suite stops enumerating per-file drivers; instead mm
runs the named framework once. The framework owns discovery, parallelism, and
fixtures; for browser runners it also owns the servers under test.

```makefile
qed.ux.playwright.runner        := playwright
qed.ux.playwright.stage.modules := $(qed.ux.stage.modules)
```

| Runner       | Language | Prepare    | Launch                | The suite supplies |
|--------------|----------|------------|-----------------------|--------------------|
| `playwright` | node     | `staged`   | `npx playwright test` | `stage.modules` |
| `vitest`     | node     | `staged`   | `npx vitest run`      | `stage.modules` |
| `pytest`     | python   | `plain`    | `pytest`              | an importable package |
| `catch2`     | c++      | `compiled` | the built binary      | `extern := catch2`, C++17 |
| `gtest`      | c++      | `compiled` | the built binary      | `extern := gtest`, C++17 |

The **prepare** kind decides what mm does before launching:

- `staged` — mirror the suite into a staging directory and link `stage.modules`
  in as `node_modules`; run the launch command from there. (Playwright, Vitest.)
- `plain` — nothing; run the launch command in the suite directory. (pytest.)
- `compiled` — compile the suite's sources into one binary and run it; the binary
  is the launch command. (Catch2, GoogleTest.)

**Overrides.** A suite may refine the invocation:

```makefile
qed.ux.playwright.runner.launch := npx playwright test --project=readonly
qed.ux.playwright.argv          := --reporter=line
qed.ux.playwright.env           := CI=1
```

### Node runners (Playwright, Vitest)

Both run `staged`, so they need a populated `node_modules`. Point `stage.modules`
at the web bundle's modules — mm's webpack/vite bundles install into their staging
area, which is exactly where the runner should resolve packages. Playwright's
browser binaries are located by `PLAYWRIGHT_BROWSERS_PATH` (set it once, in your
shell profile, to a shared cache). Servers under test, and serial-vs-parallel
routing, belong in `playwright.config.ts` (`webServer`, projects,
`test.describe.serial`), not in mm.

### Python runner (pytest)

pytest runs in the suite directory and discovers `test_*.py` itself, against the
package the suite depends on (already importable in the active environment). No
staging.

### C++ runners (Catch2, GoogleTest)

A `compiled` runner compiles every source in the suite into one binary that
self-registers its test cases, then runs it. The suite names the framework as an
external dependency and selects the language standard; the runner contributes the
entry-point library (`Catch2Main`, `gtest_main`) so your sources need no `main`:

```makefile
qed.lib.catch2.runner   := catch2
qed.lib.catch2.extern   := catch2
qed.lib.catch2.c++.flags := $($(compiler.c++).std.c++17)
```

C++ externs are only available once `mm --setup` has recorded where they live.
After installing a framework — or after mm gains support for a new one — the
package database may be stale; regenerate it with `mm extern.db.clean` (the next
build rebuilds it), and confirm with `mm extern.db.info`.

---

## Running and inspecting

```
mm <suite>            # build/prepare and run the suite
mm <suite>.clean      # remove its build/staging artifacts
mm <suite>.info       # show the suite's configuration
mm tests              # run every suite in the project
```

---

## Choosing a model

- A handful of independent checks, no framework needed → **per-file drivers**
  (silence is pass).
- A node test that imports third-party packages or app modules → a **staged**
  `.mjs` driver, or the **vitest** runner for a real framework with jsdom.
- Browser/end-to-end against a running server → the **playwright** runner.
- Python → **pytest**.
- C++ with a framework → **catch2** or **gtest**.


# end of file
