# mm — Frequently Asked Questions

## Getting started

### Do I need to write makefiles?

No. You write a declarative configuration file, `.mm/{project}.mm`, that lists
what you are building. mm discovers your sources and drives GNU make from there.

```makefile
myproject.libraries := mylib.lib

mylib.lib.stem := mylib
mylib.lib.root := lib/mylib/
```

### How does mm find my source files?

mm scans the directory named in `{asset}.root` and picks up every `.cc`, `.c`,
`.cu`, `.f`, etc. file it finds there. For projects that span multiple
subdirectories, list them explicitly:

```makefile
mylib.lib.root        := src/
mylib.lib.directories := ./ geometry/ physics/ io/
```

### Where do the build products go?

mm has four **modes** that control where build products land, selected with
`--mode`:

| Mode | Intermediate files (`bldroot`) | Installed products (`prefix`) |
|------|-------------------------------|-------------------------------|
| `dev` (default) | `builds/{target}/` | `products/` |
| `conda` | `builds/{env}/{target}/` | conda environment root (auto-detected) |
| `macports` | `builds/macports/{target}/` | MacPorts root (auto-detected) |
| `ubuntu` | `builds/ubuntu/{target}/` | `/usr` |

The `conda`, `macports`, and `ubuntu` modes resolve their prefix automatically
from the package manager and are the right choice when you want build products
installed into a managed environment.

The `dev` default puts everything inside the source tree — `builds/` and
`products/` land at the project root. This is intentionally permissive for
getting started, but it is not the recommended setup for anything beyond a quick
experiment. Polluting the source tree makes clean-ups error-prone and breaks
tools that assume the tree only contains sources.

**Recommended practice for `dev` mode:** set `bldroot` and `prefix` in
`.mm/mm.yaml` to locations outside the source tree:

```yaml
mm:
  bldroot: ~/tmp/builds/myproject
  prefix: ~/.local
```

Both can also be overridden at the command line with `--bldroot` and `--prefix`,
or left in place via the `mm_bldroot` and `mm_prefix` environment variables.

### Can I build more than one configuration at a time?

Each invocation produces one configuration. Use `--target` to choose it:

```bash
mm                       # default: debug + shared
mm --target=opt          # optimised
mm --target=opt,shared   # optimised + shared libraries
```

Each target lands in its own subdirectory of `builds/`, so configurations
do not interfere with each other.

---

## Configuration

### Where do I configure external dependencies?

In order of preference:

1. `~/.mm/{user}@{hostname}.mm` — machine-specific paths, never committed
2. `~/.mm/config.mm` — user-wide defaults
3. `.mm/{project}.mm` — project-level overrides (rarely the right place)

```makefile
# ~/.mm/config.mm
cuda.dir   := /usr/local/cuda-12
hdf5.dir   := /opt/hdf5
mpi.flavor := openmpi
```

### How do I configure mm itself?

mm reads `.mm/mm.yaml` at the start of every build. Any option that can be
passed on the command line can be set there instead. This is the right place
to record your preferred `mode`, `bldroot`, `prefix`, compiler suite, and
parallelism settings so you don't have to repeat them on every invocation:

```yaml
mm:
  mode: dev
  bldroot: ~/tmp/builds/myproject
  prefix: ~/.local
  target: opt, shared
  compilers: clang, python/python3
  slots: 8
  local: Make.local
```

`pyre` environment variable interpolation is available inside string values,
which is useful for building into a conda environment whose name changes:

```yaml
mm:
  mode: conda
  prefix: "{pyre.environ.CONDA_PREFIX}"
  bldroot: "{pyre.environ.HOME}/tmp/builds/{pyre.environ.CONDA_DEFAULT_ENV}"
```

If you are on a branch named `feature-x`, mm also loads `.mm/feature-x.yaml`
*after* `mm.yaml` so branch-specific overrides can live in their own file and
don't pollute the shared configuration.

See `docs/command-line-reference.md` for the full list of configurable options.

### How do I declare that a library depends on an external package?

Add the package name to `extern`:

```makefile
mylib.lib.extern := mpi hdf5 cuda
```

mm has pre-configured support for most common scientific and systems packages.
If a package is not pre-configured, define its variables in `~/.mm/config.mm`:

```makefile
mypackage.dir       := /opt/mypackage
mypackage.incpath   := $(mypackage.dir)/include
mypackage.libpath   := $(mypackage.dir)/lib
mypackage.libraries := foo bar
```

### How do I set compiler flags?

On a specific asset:

```makefile
mylib.lib.c++.flags += $($(compiler.c++).std.c++20) -Wall
```

### How do I set preprocessor defines?

```makefile
mylib.lib.c++.defines += MYLIB_ENABLE_SIMD MYLIB_VERSION=2
```

Defines set on a library are not automatically inherited by extensions that
wrap it or tests that link it. Each asset's defines are explicit.

### How do I exclude files from a library?

```makefile
mylib.lib.sources.exclude := src/old.cc src/scratch.cc
mylib.lib.headers.exclude := src/deprecated.h
```

### How do I do a conditional build based on whether a package is available?

```makefile
ifdef cuda.dir
    mylib.lib.extern          += cuda
else
    mylib.lib.sources.exclude += gpu_solver.cu
endif
```

### How do I inject version information into my source files?

Declare a template file under `headers.autogen` and supply a substitution table:

```makefile
mylib.lib.headers.autogen := version.h.in
mylib.lib.autogen = \
    @MAJOR@|$(mylib.major)       \
    @MINOR@|$(mylib.minor)       \
    @MICRO@|$(mylib.micro)       \
    @REVISION@|$(mylib.revision)
```

mm extracts version numbers from the most recent matching git tag and writes
the generated header to the build tree. The same mechanism works for Python
packages via `meta.py.in`. Edit the template; never edit the generated file.

---

## Portability

### What is portinfo?

`portinfo` is a header generated by mm at build time from the detected
toolchain. It sets the platform and compiler macros needed to handle
differences across operating systems and compilers without scattering `#ifdef`
through your source.

Every C++ source file in an mm project begins with:

```cpp
#include <portinfo>
```

The header is installed alongside your library's headers and is available to
any downstream asset that depends on an mm-built library.

---

## Building

### How do I do a clean build?

```bash
rm -rf builds products && mm
```

mm also exposes lighter-weight make targets:

```bash
mm clean   # remove intermediate files for the current target
mm tidy    # remove all build products for the current target
```

### How do I control parallelism?

mm uses all available cores by default.

```bash
mm --slots=4   # use 4 cores
mm --serial    # single-threaded
```

### How do I see what mm is doing?

```bash
mm --show      # print the make command line before running it
mm --verbose   # pass --verbose to make; shows every compiler invocation
mm --dry       # print what would happen without doing anything
```

---

## Testing

### How do I run tests?

```bash
mm test
```

This passes the `test` target to make. All test suites declared in the project
manifest run in dependency order.

### How do I declare a test suite?

Each source file under the test suite's root becomes an independent test
binary. Silence is pass; any output signals a failure.

```makefile
myproject.tests := mylib.lib.tests

mylib.lib.tests.stem          := mylib.lib
mylib.lib.tests.prerequisites := mylib.lib
mylib.lib.tests.extern        := mylib.lib
mylib.lib.tests.c++.flags     += $($(compiler.c++).std.c++20)
```

`prerequisites` names the assets that must be built before the tests can
compile or run. `extern` provides include paths and link flags.

For Python test suites, prerequisites are sufficient — no `extern` needed:

```makefile
mylib.pkg.tests.stem          := mylib.pkg
mylib.pkg.tests.prerequisites := mylib.pkg
```

For tests that need explicit command-line arguments, declare named cases:

```makefile
tests.myapp.driver.cases := case1 case2
case1.argv := --input test1.dat
case2.argv := --input test2.dat --verbose
```

---

## pyre integration

### What is journal and how do I use it from C++?

`journal` is a structured logging framework that ships with pyre and works
identically in C++ and Python. To use it in a C++ library, add `pyre` to
the library's extern list:

```makefile
mylib.lib.extern := pyre
```

Then open a channel at the call site:

```cpp
auto channel = pyre::journal::info_t("mylib.solver");
channel << "starting solve" << pyre::journal::endl;
```

Available channel types: `debug_t`, `info_t`, `warning_t`, `error_t`,
`firewall_t`. `error_t` and `firewall_t` are fatal by default; use `firewall_t`
for developer-facing assertions and `error_t` for user-facing errors.

### How do I enable debug channels in C++?

Debug channels compile to no-ops unless `JOURNAL_DEBUG` is defined. Set it
explicitly on the assets that need it:

```makefile
mylib.lib.c++.defines += JOURNAL_DEBUG
```

This define is not inherited by extensions that wrap the library or tests that
link it. Only set it where debug channels are actually used.

### How do I use journal from Python?

```python
import journal

channel = journal.info("mylib.driver")
channel.log(f"loaded {n} records")
```

For multi-line entries, use `line` to add lines and `log` to flush:

```python
channel.line(f"min: {lo:.6f} s")
channel.line(f"avg: {avg:.6f} s")
channel.log(f"max: {hi:.6f} s")
```

Channel names are dotted strings. Deactivating a parent silences all children:

```python
journal.info("mylib").deactivate()   # silences mylib.driver, mylib.solver, etc.
```

### How do I initialise journal in a C++ test or application?

```cpp
pyre::journal::application("myapp");   // set the program name — must come first
pyre::journal::init(argc, argv);       // process --journal.* command-line arguments
```

The order matters. `application` must be called before `init`.

### How do I replace argparse with pyre.application?

Inherit from `pyre.application` and declare traits at the class level:

```python
class App(pyre.application, family="myapp.app"):
    """Run a simulation and report results."""

    count = pyre.properties.int(default=1)
    count.doc = "number of iterations"

    @pyre.export
    def main(self, *args, **kwds):
        command = list(self.argv)   # positional arguments not consumed by traits
        ...
        self.info.log(f"done in {elapsed:.3f} s")
        return 0

if __name__ == "__main__":
    app = App(name="myapp")
    raise SystemExit(app.run())
```

Traits are automatically wired to `--{name}` on the command line and to
configuration files. `self.info`, `self.warning`, and `self.error` are
pre-configured journal channels. `self.argv` holds any remaining positional
arguments.

### How do I make an implementation selectable at run time?

Declare a protocol that names the interface and its preferred default:

```python
class Solver(mylib.protocol, family="mylib.protocols.solver"):
    @mylib.provides
    def solve(self, problem): ...

    @classmethod
    def pyre_default(cls, **kwds):
        return mylib.components.DirectSolver
```

Implement it as a component:

```python
class DirectSolver(
    mylib.component,
    family="mylib.solvers.direct",
    implements=mylib.protocols.solver,
):
    @mylib.export
    def solve(self, problem): ...
```

Declare a trait that holds the protocol:

```python
solver = mylib.protocols.solver()
solver.doc = "the solver implementation to use"
```

The user can now switch implementations at the command line:

```bash
myapp --myapp.solver=mylib.solvers.iterative -- ...
```

or in a configuration file without touching the source.

---

## Session management

### How do I wire mm into my shell?

Wrap `mm --activate` in a shell function and call it after building:

```bash
mm.activate() {
    eval "$(mm --quiet --activate)"
}
```

This prepends the build's `bin/` to `PATH` and the Python package directory to
`PYTHONPATH`. It must be a function, not an alias — `eval` inside a bash alias
executes in the wrong scope. `--quiet` suppresses the mm banner so only the
export lines reach `eval`. Calling `mm.activate` when a build is already active
is safe; it ejects the previous activation first.

### How do I use branch-scoped builds?

`mm --branch=on` derives a tag from the current git state (`{project}/{branch}`)
and activates the corresponding installation tree. Build products land in:

```
builds/{suite}/{project}/{branch}/{target}/
products/{suite}/{project}/{branch}/{target}/
```

All branch builds are isolated from each other and from the untagged build.
The conventional wrappers:

```bash
mm.branch() {
    eval "$(mm --quiet --branch=on)"
}

mm.clear() {
    eval "$(mm --quiet --branch=off)"
}
```

`mm.clear` removes the tag and returns to the unscoped installation tree. A
ready-made version of all three functions lives in
`examples/step08/etc/bash/activate.bash`.

---

## Troubleshooting

### mm says my GNU make is too old

You need GNU make 4.2.1 or later. On macOS, `make` is BSD make; install
`gmake` via Homebrew or MacPorts and make sure it is on your `PATH`.

### mm cannot find my project configuration

mm walks up from the current directory looking for a `.mm/` subdirectory.
Make sure `.mm/{project}.mm` exists and you are running mm from somewhere
inside the project tree.

### My library is not linking against a dependency

Check that `extern` names the package and that the package variables
(`{pkg}.dir`, `{pkg}.libpath`, etc.) are set in your mm configuration files.

### Headers are not being installed

All `.h` files under `{asset}.root` are installed by default. If some are
missing, check that the relevant subdirectory is listed in
`{asset}.directories` and is not excluded via `{asset}.headers.exclude`.

### An extension produces warnings about the language standard

Extension binding files include the library's headers and must be compiled at
the same standard level. Set the standard flag explicitly on the extension:

```makefile
mylib.ext.lib.c++.flags += $($(compiler.c++).std.c++20)
```

Do not rely on inheritance from the library — extension compile flags are
independent.

---

## Design

### Does mm generate makefiles?

No. mm uses a library of make fragments installed to
`{prefix}/share/mm/make/`. GNU make loads those fragments directly at run
time. There are no generated files to check in or regenerate.

# end of file
