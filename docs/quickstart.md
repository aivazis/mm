# mm Quickstart Guide

Get from zero to a working build in 5 minutes.

## What is mm?

**mm** is an opinionated build framework that combines:
- **Python** for intelligent project discovery and configuration
- **GNU Make** for parallel, dependency-driven compilation

Key features:
- **Zero boilerplate**: No makefiles needed, just declare what you're building
- **Auto-discovery**: Finds sources automatically based on directory structure
- **Multi-language**: C, C++, Fortran, CUDA, Python, Cython, JavaScript
- **Smart dependencies**: Handles external packages (MPI, CUDA, HDF5, etc.)
- **Parallel by default**: Uses all CPU cores automatically

## Installation

```bash
# Clone or download mm
cd /path/to/mm

# Install to your preferred location
./install.sh ~/.local          # User install
# or
./install.sh /usr/local        # System-wide (needs sudo)

# Add to PATH if using ~/.local
export PATH="$HOME/.local/bin:$PATH"

# Verify installation
mm --help
```

## Quick Start: Build a C++ Library

### 1. Create Project Structure

```bash
mkdir myproject && cd myproject

# Create the magic directory
mkdir .mm

# Create source directory
mkdir -p lib/mylib
```

### 2. Write Some Code

```bash
# lib/mylib/hello.h
cat > lib/mylib/hello.h << 'EOF'
#pragma once
const char* greet();
EOF

# lib/mylib/hello.cc
cat > lib/mylib/hello.cc << 'EOF'
#include "hello.h"
const char* greet() { return "Hello from mm!"; }
EOF

# lib/mylib/main.cc
cat > lib/mylib/main.cc << 'EOF'
#include "hello.h"
#include <iostream>
int main() {
    std::cout << greet() << std::endl;
    return 0;
}
EOF
```

### 3. Configure the Build

This is the **only** configuration file you need:

```bash
# .mm/myproject.mm
cat > .mm/myproject.mm << 'EOF'
# -*- Makefile -*-

# Declare we're building a library
myproject.libraries := mylib.lib

# Library configuration
mylib.lib.stem := mylib
mylib.lib.root := lib/mylib/

# C++ standard
mylib.lib.c++.flags := $($(compiler.c++).std.c++17)
EOF
```

### 4. Build!

```bash
mm
```

That's it! mm will:
- Find all `.cc` and `.h` files in `lib/mylib/`
- Compile them in parallel
- Create a shared library: `products/lib/libmylib.so`
- Install headers to: `products/include/mylib/`

### Output Structure

```
myproject/
├── .mm/
│   └── myproject.mm          # Your only config file
├── lib/mylib/                # Source code
│   ├── hello.h
│   ├── hello.cc
│   └── main.cc
├── builds/                   # Intermediate build products (auto-created)
│   └── debug-shared-linux-x86_64/
│       └── mylib.lib/
│           ├── hello.o
│           └── ...
└── products/                 # Final build products (auto-created)
    ├── bin/
    ├── include/mylib/
    │   └── hello.h
    └── lib/
        └── libmylib.so
```

## Understanding Auto-Discovery

**mm doesn't need explicit source lists**. It discovers files based on:

### Simple Case: Single Directory

```makefile
mylib.lib.root := lib/mylib/
```

mm automatically finds **all** `.cc`, `.c`, `.f`, `.cu` files in that directory.

### Multiple Directories

For large projects, specify which directories to scan:

```makefile
mylib.lib.root := src/
mylib.lib.directories := \
    ./ \
    geometry/ \
    physics/ \
    io/
```

This tells mm to look in:
- `src/`
- `src/geometry/`
- `src/physics/`
- `src/io/`

### Excluding Files

Sometimes you need to exclude specific files:

```makefile
mylib.lib.sources.exclude := \
    src/old_code.cc \
    src/experimental/prototype.cc

mylib.lib.headers.exclude := \
    src/deprecated.h
```

### Advanced: Conditional Compilation

Enable/disable features based on available dependencies:

```makefile
# .mm/libsummit.dirs (in a separate file for clarity)
define libsummit.srcdirs :=
    ./
    fem/
    solvers/
    io/
endef

# .mm/myproject.mm
include libsummit.dirs

mylib.lib.directories := ${addprefix $(mylib.lib.root),$(libsummit.srcdirs)}

# Conditional compilation based on availability
ifdef cuda.dir
    mylib.lib.extern += cuda
else
    mylib.lib.sources.exclude += solvers/gpu_solver.cu
endif

ifdef hdf5.dir
    mylib.lib.extern += hdf5
else
    mylib.lib.sources.exclude += io/hdf5_writer.cc
endif
```

## Building Python Packages

```bash
mkdir -p pkg/myapp
cat > .mm/myproject.mm << 'EOF'
# -*- Makefile -*-

myproject.packages := myapp.pkg

myapp.pkg.stem := myapp
myapp.pkg.root := pkg/myapp/
EOF

# Create Python code
cat > pkg/myapp/__init__.py << 'EOF'
def hello():
    return "Hello from Python!"
EOF

mm
```

Installs to: `products/packages/myapp/`

## Building Python Extensions (C++/Python bindings)

```bash
mkdir -p ext/myext
cat > .mm/myproject.mm << 'EOF'
# -*- Makefile -*-

myproject.libraries := mylib.lib
myproject.packages := myapp.pkg
myproject.extensions := myext.ext

# Extension wraps the C++ library
myext.ext.stem := myext
myext.ext.root := ext/myext/
myext.ext.pkg := myapp.pkg          # Install into this package
myext.ext.wraps := mylib.lib        # Links against this library
myext.ext.extern := mylib.lib python
EOF
```

## External Dependencies

mm has pre-configured support for 20+ libraries:

```makefile
# Link against external libraries
mylib.lib.extern := mpi cuda hdf5 gsl petsc

# If they're in standard locations, mm finds them
# Otherwise configure in ~/.mm/config.mm:
#
# cuda.dir := /usr/local/cuda
# cuda.incpath := $(cuda.dir)/include
# cuda.libpath := $(cuda.dir)/lib64
```

Supported packages: `mpi`, `cuda`, `hdf5`, `vtk`, `petsc`, `slepc`, `gsl`, `fftw`, `metis`, `parmetis`, `pyre`, `python`, `numpy`, `gtest`, `gmsh`, `gdal`, `libpq`, and more.

## Build Targets

mm supports multiple build configurations:

```bash
mm                          # Default: debug + shared
mm --target=opt             # Optimized build
mm --target=opt,shared      # Optimized + shared libraries
mm --target=prof            # With profiling
mm --target=cov             # With coverage

# Parallel control
mm -j 8                     # Use 8 cores
mm --serial                 # Single-threaded (for debugging)
```

## Common Tasks

### Clean builds
```bash
rm -rf builds products
mm
```

### Install elsewhere
```bash
mm --prefix=/opt/myproject
```

### Verbose output
```bash
mm --verbose                # See all compiler commands
mm --show                   # Show make invocation
```

### Just tests
```bash
mm test                     # Run all tests
mm test.mylib               # Run specific test suite
```

## Configuration Hierarchy

mm searches for configuration in this order:
1. Command-line arguments (`--prefix`, `--bldroot`, `--target`)
2. Environment variables (`mm_prefix`, `mm_bldroot`, `mm_targets`)
3. User configuration files (in `~/.mm/`)
4. Project configuration (in `.mm/`)

### User Configuration

Set up external dependencies once:

```bash
mm --setup                  # Creates ~/.mm/config.mm

# Edit ~/.mm/config.mm - applies to ALL projects
cat >> ~/.mm/config.mm << 'EOF'
# CUDA
cuda.dir := /usr/local/cuda-12.0
cuda.incpath := $(cuda.dir)/include
cuda.libpath := $(cuda.dir)/lib64

# HDF5
hdf5.dir := /opt/hdf5
hdf5.incpath := $(hdf5.dir)/include
hdf5.libpath := $(hdf5.dir)/lib
EOF
```

### Host-Specific Configuration

mm automatically loads `~/.mm/{user}@{hostname}.mm` for machine-specific settings:

```bash
# ~/.mm/rapa@laptop.mm
cat > ~/.mm/rapa@laptop.mm << 'EOF'
# -*- Makefile -*-

# System paths
sys.prefix := /usr
sys.opt.prefix := /opt/apps

# MPI (using module-provided path)
mpi.version := 4.1.4
mpi.flavor := openmpi
mpi.dir := $(MPI_HOME)
mpi.executive := mpirun

# PETSc with MPI
petsc.dir := $(sys.prefix)
petsc.incpath := $(petsc.dir)/include/openmpi-x86_64/petsc
petsc.libpath := $(petsc.dir)/lib64/openmpi/lib

# CUDA
cuda.dir := /usr/local/cuda
cuda.incpath := $(cuda.dir)/include
cuda.libpath := $(cuda.dir)/lib64

# Python
python.version := 3.9
python.dir := $(sys.prefix)
python.incpath := $(python.dir)/include/python$(python.version)

# GSL, Eigen, etc. in standard locations
gsl.dir := $(sys.prefix)
eigen.dir := $(sys.prefix)
pyre.dir := $(sys.opt.prefix)/pyre
EOF
```

This way, each developer/machine has its own configuration without affecting the project.

## Environment Variables

mm supports environment variables for CI/CD and module systems:

```bash
# Set build configuration
export mm_targets="opt,shared"          # Build targets (comma-separated)
export mm_compiler="gcc"                # Compiler choice
export mm_prefix="/opt/myproject"       # Install location
export mm_bldroot="/tmp/builds"         # Build staging area

# Build with these settings
mm
```

### Using with Environment Modules

Create a module file for your build products:

```lua
-- myproject/gcc-opt.lua
setenv("mm_system", "mm")
setenv("mm_abi", "opt-shared-linux-x86_64")
setenv("mm_target", "opt")
setenv("mm_compiler", "gcc")
setenv("mm_prefix", "/opt/myproject/gcc/opt-shared-linux-x86_64")
setenv("mm_bldroot", "/tmp/builds/myproject/gcc")
setenv("mm_targets", "opt,shared")
setenv("mm_compilers", "gcc")

prepend_path("PATH", "/opt/myproject/gcc/opt-shared-linux-x86_64/bin")
prepend_path("PYTHONPATH", "/opt/myproject/gcc/opt-shared-linux-x86_64/packages")
prepend_path("LD_LIBRARY_PATH", "/opt/myproject/gcc/opt-shared-linux-x86_64/lib")

whatis("myproject built with gcc, optimized")
```

### Injecting Build Environment

mm can generate shell commands to set up the build environment:

```bash
# For bash/sh
eval $(mm --paths=sh)

# For csh/tcsh
eval `mm --paths=csh`

# For fish
eval (mm --paths=fish)

# This sets: PATH, PYTHONPATH, MM_INCLUDES, MM_LIBPATH
```

This is useful for:
- Running binaries built by mm
- Using Python packages built by mm
- Linking against libraries built by mm

To remove mm paths from environment:

```bash
eval $(mm --paths=sh --clear)
```

## Project Configuration

Override defaults in `.mm/myproject.mm`:

```makefile
# -*- Makefile -*-

# Set project name (optional, defaults to directory name)
project := myproject

# Compiler flags for everything
myproject.common.c++.flags := -Wall -O3 $($(compiler.c++).std.c++20)

# Apply to all libraries
${foreach lib, $(myproject.libraries), \
    ${eval $(lib).c++.flags := $(myproject.common.c++.flags)} \
}
```

## Next Steps

- See `examples/hello/` for a comprehensive multi-language project
- See `examples/simple/` for minimal examples
- Read [Examples Explained](examples.md) for detailed walkthroughs
- Read [Command-Line Reference](command-line-reference.md) for all options
- Use `mm --help` for built-in help
- Use `mm <project>.help` or `mm <asset>.info` for runtime target information

## Summary

The mm philosophy:
1. **Declare what you're building** in `.mm/{project}.mm`
2. **Organize code by directory structure**
3. **Let mm discover and build everything**

No makefiles. No CMakeLists. Just code and a simple declaration file.
