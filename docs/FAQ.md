# mm — Frequently Asked Questions

## Getting started

### Do I need to write makefiles?

No. You write one declarative configuration file, `.mm/{project}.mm`, that
lists what you are building. mm discovers your sources and drives GNU make
from there.

```makefile
myproject.libraries := mylib.lib

mylib.lib.stem := mylib
mylib.lib.root := lib/mylib/
```

### How does mm find my source files?

mm scans the directory named in `{asset}.root` and picks up every `.cc`,
`.c`, `.cu`, `.f`, etc. file it finds there. For larger projects that span
multiple subdirectories, list them explicitly:

```makefile
mylib.lib.root := src/
mylib.lib.directories := ./ geometry/ physics/ io/
```

### Where do the build products go?

By default:
- intermediate files (`.o`, `.d`): `builds/{target-tag}/`
- installed products: `products/{bin,lib,include,packages}/`

Both locations can be overridden with `--bldroot` and `--prefix`.

### Can I build more than one configuration at a time?

Each invocation produces one configuration. Use `--target` to choose it:

```bash
mm                       # default: debug + shared
mm --target=opt          # optimised
mm --target=opt,shared   # optimised + shared libraries
```

Each target lands in its own subdirectory of `builds/`, so configurations
do not interfere with each other.

## Configuration

### Where do I configure external dependencies?

In order of preference:

1. `~/.mm/{user}@{hostname}.mm` — machine-specific paths, never committed
2. `~/.mm/config.mm` — user-wide defaults
3. `.mm/{project}.mm` — project-level overrides (rarely the right place)

```makefile
# ~/.mm/config.mm
cuda.dir    := /usr/local/cuda-12
hdf5.dir    := /opt/hdf5
mpi.flavor  := openmpi
```

### How do I declare that a library depends on an external package?

Add the package name to `extern`:

```makefile
mylib.lib.extern := mpi hdf5 cuda
```

mm has pre-configured support for most common scientific packages. If a
package is not pre-configured, define its variables in `~/.mm/config.mm`:

```makefile
mypackage.dir     := /opt/mypackage
mypackage.incpath := $(mypackage.dir)/include
mypackage.libpath := $(mypackage.dir)/lib
mypackage.libraries := foo bar
```

### How do I set compiler flags?

On a specific asset:

```makefile
mylib.lib.c++.flags += $($(compiler.c++).std.c++20) -Wall
```

### How do I exclude files from a library?

```makefile
mylib.lib.sources.exclude := src/old.cc src/scratch.cc
mylib.lib.headers.exclude := src/deprecated.h
```

### How do I do a conditional build based on whether a package is available?

```makefile
ifdef cuda.dir
    mylib.lib.extern += cuda
else
    mylib.lib.sources.exclude += gpu_solver.cu
endif
```

## Building

### How do I do a clean build?

```bash
rm -rf builds products && mm
```

mm also exposes `mm clean` and `mm tidy` make targets for lighter-weight
cleanup.

### How do I control parallelism?

mm uses all available cores by default.

```bash
mm --slots=4     # use 4 cores
mm --serial      # single-threaded
```

### How do I see what mm is doing?

```bash
mm --show        # print the make command line before running it
mm --verbose     # pass --verbose to make; shows every compiler invocation
mm --dry         # print what would happen without doing anything
```

## Testing

### How do I run tests?

```bash
mm test
```

This passes the `test` target to make. Individual test suites can be
targeted by name.

### How do I declare a test suite?

For implicit tests (each source file is a self-contained test driver):

```makefile
myproject.tests := mylib.tests

mylib.tests.stem         := mylib.tests
mylib.tests.extern       := mylib.lib
mylib.tests.prerequisites := mylib.lib
```

For tests that need command-line arguments, declare explicit cases:

```makefile
tests.myapp.driver.cases := case1 case2
case1.argv := --input test1.dat
case2.argv := --input test2.dat --verbose
```

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
(`{pkg}.dir`, `{pkg}.libpath`, etc.) are set in your configuration.

### Headers are not being installed

All `.h` files under `{asset}.root` are installed by default. If some are
missing, check that the relevant subdirectory is listed in
`{asset}.directories` and not excluded via `{asset}.headers.exclude`.

## Philosophy

### Why not CMake?

mm is optimised for a specific workflow: projects that combine C++, Fortran,
CUDA, and Python, targeting high-performance computing environments where
developers maintain their own toolchain configurations. It trades generality
for very low per-project configuration overhead.

### Does mm generate makefiles?

No. mm uses a library of make fragments in `{mm-install}/share/mm/make/`.
GNU make includes those fragments directly at run time. There are no
generated files to check in.
