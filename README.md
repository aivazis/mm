# mm

mm is a build orchestration framework for projects that mix C, C++, Fortran,
CUDA, and Python. You declare what you are building in a small configuration
file; mm discovers your sources, resolves external dependencies, and drives
GNU make to compile, link, and install everything in parallel.

mm has no generated makefiles. Its build logic lives in a library of make
fragments that GNU make loads at run time. There is nothing to regenerate when
you add a source file or change a dependency — running `mm` is always
sufficient.

---

## The configuration model

Each project has a `.mm/` directory at its root. The top-level file is named
after the project:

```makefile
# .mm/myproject.mm
myproject.libraries  := mylib.lib
myproject.packages   := mylib.pkg
myproject.extensions := mylib.ext
myproject.tests      := mylib.lib.tests mylib.pkg.tests
```

This is the complete project manifest. Each name in those lists is an asset
with its own configuration file in `.mm/`. The project file delegates all
detail to those files and stays small regardless of how large the project grows.

Asset configurations use the same flat namespace of dotted names:

```makefile
# .mm/mylib.lib
mylib.lib.stem   := mylib
mylib.lib.root   := lib/mylib/
mylib.lib.extern := mpi hdf5
mylib.lib.c++.flags += $($(compiler.c++).std.c++20)
```

`stem` controls the output name. `root` is the directory mm scans for sources.
`extern` is the list of external packages the asset needs — mm translates each
name to the correct include paths, compile definitions, and link flags.


## Asset types

mm understands six asset types.

**Libraries** compile and link a set of C, C++, Fortran, or CUDA source files
into a static or shared library. mm discovers all sources under `{asset}.root`
automatically.

**Packages** install a Python package tree. mm copies the source to the
installation prefix and generates any templated files (version metadata, etc.)
from substitution templates at build time.

**Extensions** build pybind11 modules that expose C++ libraries to Python.
The `wraps` variable names the library being bound, giving mm enough context
to set up include paths and link flags without repetition. A capsule variable
controls whether the extension participates in PyCapsule sharing with other
extensions in the same process.

**Tests** compile and run a test suite. Each source file under `{asset}.root`
becomes an independent test binary. mm links each binary against the assets
listed in `extern`, runs all of them, and reports any that produce output.
Silence is pass.

**Drivers** are executable scripts installed to `bin/`. mm installs every
file in the project's `bin/` directory without requiring a configuration entry.

**Verbatim** assets copy files to the installation prefix without processing —
useful for configuration files, schemas, and other static content.

All asset types appear in the project manifest under the appropriate plural key
(`libraries`, `packages`, `extensions`, `tests`). mm handles the dependency
ordering between them.


## Source discovery and conventions

mm scans `{asset}.root` and picks up every source file whose extension matches
a supported language. For projects that span multiple subdirectories:

```makefile
mylib.lib.directories := ./ geometry/ physics/ io/
```

Source files can be excluded individually:

```makefile
mylib.lib.sources.exclude := src/scratch.cc
```

The expected directory layout mirrors the namespace hierarchy. A library for
the `mylib::` C++ namespace lives under `lib/mylib/`, with one file trio per
class (`Foo.h`, `Foo.icc`, `Foo.cc`), a `forward.h` for forward declarations,
and a `public.h` that exposes the full API of that directory level. A sibling
`lib/mylib.h` includes `mylib/public.h` so clients need only `#include
<mylib.h>`.

Python packages follow the same logic: `pkg/mylib/` maps to the installed
`mylib` package. The `tests/` directory mirrors the source tree:
`tests/mylib.lib/`, `tests/mylib.ext/`, and `tests/mylib.pkg/` test each
asset independently.


## Generated files

Version information and other build-time metadata can be injected into source
files through a template substitution mechanism. A template named
`version.h.in` in a library's source directory is processed at build time:

```makefile
mylib.lib.headers.autogen := version.h.in
mylib.lib.autogen = \
    @MAJOR@|$(mylib.major)    \
    @MINOR@|$(mylib.minor)    \
    @MICRO@|$(mylib.micro)    \
    @REVISION@|$(mylib.revision)
```

mm extracts version numbers from the most recent git tag that matches the
project's version tag pattern and fills in the `@TOKEN@` placeholders. The
same mechanism works for Python packages via `meta.py.in`. The generated file
is always a build product; you edit the template, not the output.


## External dependencies

mm ships pre-configured support for a broad set of scientific and systems
packages:

cantera, CGAL, CSPICE, CUDA, Eigen, FFTW, fmt, GDAL, GeoTIFF, Gmsh, GSL,
GTest, HDF5, Kokkos, libpq, METIS, MKL, MPI, NumPy, OpenBLAS, ParMETIS,
PETSc, PROJ, pybind11, pyre, and others.

Pointing mm to a package is a one-line addition to any asset's configuration:

```makefile
mylib.lib.extern := mpi hdf5 pybind11
```

Machine-specific paths are declared in `~/.mm/config.mm`, which is never
committed to the project repository:

```makefile
# ~/.mm/config.mm
cuda.dir  := /usr/local/cuda-12
hdf5.dir  := /opt/hdf5
```

For packages without pre-configured support, the same variables work without
any mm internals:

```makefile
mypackage.dir       := /opt/mypackage
mypackage.incpath   := $(mypackage.dir)/include
mypackage.libpath   := $(mypackage.dir)/lib
mypackage.libraries := foo bar
```

mm also integrates with conda. Running `mm --pkgdb=conda` builds a database
of installed packages and uses it to resolve external dependencies
automatically.


## Portability

Every C++ source file in an mm project begins with:

```cpp
#include <portinfo>
```

`portinfo` is generated at build time from the detected toolchain. It sets the
platform and compiler macros your code needs to handle differences across
operating systems and compilers without scattering `#ifdef` throughout the
source. The header is installed by mm and is always available to any asset that
depends on a library compiled with mm.


## pyre integration

mm is the build system for [pyre](https://github.com/pyre/pyre), a Python
component framework. Projects that use pyre gain access to several layers of
integration that go beyond compilation.

### journal — structured logging across language boundaries

`pyre` ships `journal`, a logging framework that works identically in C++ and
Python. The same named channel can be used from both sides of the language
boundary; channels are identified by dotted name and their state is global.

In C++:

```cpp
auto channel = pyre::journal::debug_t("mylib.solver");
channel << "step " << n << pyre::journal::endl;
```

In Python:

```python
import journal
channel = journal.info("mylib.driver")
channel.log(f"loaded {n} records")
```

Debug channels compile to no-ops unless `JOURNAL_DEBUG` is defined, making
them free in production builds:

```makefile
mylib.lib.c++.defines += JOURNAL_DEBUG
```

This define is not inherited by any other asset, including extensions that wrap
the library. Extension binding code typically does not use debug channels, and
pybind11 headers can generate spurious warnings under aggressive warning flags.
Each asset's defines are explicit.

### pyre.application — configuration-aware drivers

Applications that inherit from `pyre.application` replace `argparse` with a
declarative trait system:

```python
class App(pyre.application, family="myapp.app"):
    """Run a simulation and report results."""

    count = pyre.properties.int(default=1)
    count.doc = "number of iterations"

    @pyre.export
    def main(self, *args, **kwds): ...
```

Traits declared at the class level are automatically wired to command-line
arguments, configuration files (`.pfg`, `.yaml`, `.ini`), and the pyre
configuration store. The `family` string is the key used in configuration
files to address this component. A user can override any trait for a specific
run without touching the source:

```bash
myapp --count=100 -- some-command
```

or persistently in `~/.pyre/myapp.pfg`:

```ini
[myapp.app]
count = 100
```

### Component protocols — runtime implementation selection

pyre's component model separates the declaration of an interface from its
implementation and defers the binding between them to configuration time. A
protocol declares obligations:

```python
class Solver(mylib.protocol, family="mylib.protocols.solver"):
    @mylib.provides
    def solve(self, problem): ...

    @classmethod
    def pyre_default(cls, **kwds):
        return mylib.components.DirectSolver
```

A component implements the protocol:

```python
class DirectSolver(
    mylib.component,
    family="mylib.solvers.direct",
    implements=mylib.protocols.solver,
):
    @mylib.export
    def solve(self, problem): ...
```

An application trait that holds a solver:

```python
solver = mylib.protocols.solver()
solver.doc = "the solver implementation to use"
```

With this in place, the solver implementation is a configuration choice. The
default comes from `pyre_default` — typically the highest-performance
implementation available. A user switches implementations at the command line
without touching any code:

```bash
myapp --myapp.solver=mylib.solvers.iterative -- ...
```

This is the component system's core value: the application's structure is
defined once in code, and the wiring of its parts is deferred to the caller.


## Session management

mm manages the shell environment alongside the build.

### Activating a build

`mm --activate` emits shell export statements that add the build's `bin/` and
Python package directory to the current session's `PATH` and `PYTHONPATH`. The
conventional wrapper is a shell function (not an alias — `eval` must execute in
the calling shell's scope):

```bash
mm.activate() {
    eval "$(mm --quiet --activate)"
}
```

`--quiet` suppresses the mm banner so only the export lines reach `eval`.
`mm.activate` is idempotent: it ejects the previous activation before injecting
the new one, so calling it when a build is already active is always safe.

### Branch-scoped builds

`mm --branch=on` derives a build tag from the current git state:

```
{project}/{branch}
```

and activates the installation tree that corresponds to that tag. With a tag,
build products land in:

```
builds/{suite}/{project}/{branch}/{target}/
products/{suite}/{project}/{branch}/{target}/
```

Without a tag they land in:

```
builds/{target}/
products/{target}/
```

Branch-tagged builds are completely isolated. You can maintain separate
compiled products for every active branch and switch between them in one
command, without rebuilding anything:

```bash
mm.branch() {
    eval "$(mm --quiet --branch=on)"
}

mm.clear() {
    eval "$(mm --quiet --branch=off)"
}
```

`mm.clear` removes the tag and returns to the unscoped build.

Source these functions from `~/.bashrc` or `~/.bash_profile`. A ready-made
version lives in `examples/step08/etc/bash/activate.bash`.


## Build variants and parallelism

mm supports named build variants — combinations of optimisation level, debug
information, shared/static linking, and code coverage instrumentation. The
default build is unoptimised with debug information and shared libraries.
Override with `--target`:

```bash
mm                     # debug + shared (default)
mm --target=opt        # optimised
mm --target=opt,shared # optimised + shared
```

Each target lands in its own subdirectory of `builds/`, so all variants
co-exist without interfering.

mm uses all available cores by default. Limit parallelism with `--slots`:

```bash
mm --slots=4
```


## Requirements

- Python 3.10 or later
- [pyre](https://github.com/pyre/pyre) framework
- GNU make 4.2.1 or later (on macOS: install `gmake` via Homebrew or MacPorts)


## Installation

```bash
./install.sh ~/.local
export PATH="$HOME/.local/bin:$PATH"
```

Pass `--bash-completion` to also install tab-completion support for bash.


## Documentation

- `docs/tutorial.md` — a step-by-step walkthrough that builds a C++ timer
  library with Python bindings, a pyre application driver, and full shell
  integration; eight progressive steps, each introducing one new concept
- `docs/FAQ.md` — answers to common configuration and troubleshooting questions
- `examples/` — the complete source for each tutorial step

# end of file
