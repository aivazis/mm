# mm Frequently Asked Questions

## Getting Started

### Q: Do I need to write makefiles?

**No.** That's the whole point of mm. You only need one configuration file: `.mm/{project}.mm`

The configuration file just declares *what* you're building:
```makefile
myproject.libraries := mylib.lib
mylib.lib.stem := mylib
mylib.lib.root := lib/mylib/
```

mm automatically discovers all source files and generates the makefiles.

### Q: How does mm find my source files?

mm scans the directory specified in `{library}.root` and automatically finds all `.cc`, `.c`, `.cu`, `.f`, etc. files.

For large projects, you can specify which subdirectories to scan:
```makefile
mylib.lib.root := src/
mylib.lib.directories := geometry/ physics/ io/
```

### Q: Where do build products go?

By default:
- **Intermediate files** (`.o`, `.d`): `builds/{target}/`
- **Final products**: `products/{bin,lib,include,packages}/`

You can override with `--prefix` or `--bldroot`.

### Q: Can I have multiple build configurations?

Yes! Use `--target`:
```bash
mm --target=debug        # Debug build
mm --target=opt          # Optimized build  
mm --target=opt,shared   # Optimized + shared libs
```

Each target gets its own directory in `builds/`.

## Configuration

### Q: Where should I configure external dependencies?

Three places, in order of preference:

1. **User config** (`~/.mm/config.mm`) - for system-wide packages
2. **Host config** (`~/.mm/{user}@{host}.mm`) - for machine-specific paths
3. **Project config** (`.mm/{project}.mm`) - rarely needed, usually not the right place

Example in `~/.mm/config.mm`:
```makefile
cuda.dir := /usr/local/cuda-12.0
cuda.incpath := $(cuda.dir)/include
cuda.libpath := $(cuda.dir)/lib64
```

### Q: How do I use a dependency that's already configured?

Just add it to `extern`:
```makefile
mylib.lib.extern := mpi cuda hdf5 gsl
```

mm knows about 20+ packages. See the quickstart for the full list.

### Q: What if my dependency isn't pre-configured?

Add it to your `~/.mm/config.mm`:
```makefile
# My custom library
mypackage.version := 1.0
mypackage.dir := /opt/mypackage
mypackage.incpath := $(mypackage.dir)/include
mypackage.libpath := $(mypackage.dir)/lib
mypackage.libraries := mylib1 mylib2
```

Then use: `mylib.lib.extern := mypackage`

### Q: How do I set compiler flags?

In your `.mm/{project}.mm`:
```makefile
# For a specific library
mylib.lib.c++.flags := -Wall -O3 $($(compiler.c++).std.c++20)

# For all libraries in the project
myproject.common.c++.flags := -Wall -O3
${foreach lib, $(myproject.libraries), \
    ${eval $(lib).c++.flags := $(myproject.common.c++.flags)} \
}
```

### Q: Can I use environment variables?

Yes:
```bash
export mm_prefix=/opt/myproject
export mm_targets="opt,shared"
export mm_compiler=gcc

mm
```

This is useful for CI/CD and environment modules.

## Building

### Q: How do I do a clean build?

```bash
# Remove all build artifacts
rm -rf builds products
mm
```

mm also provides make-level clean targets: `mm clean` removes build products,
`mm tidy` removes intermediate objects, and `mm tests.clean` removes test
artifacts.  For a guaranteed fresh start, removing the directories is simplest.

### Q: How do I build in parallel?

mm builds in parallel by default, using all CPU cores.

Control it with:
```bash
mm -j 8          # Use 8 cores
mm --serial      # Single-threaded (for debugging)
```

### Q: How do I see what mm is doing?

```bash
mm --show        # Show the make command
mm --verbose     # Show all compiler commands
```

### Q: My build is failing. How do I debug?

1. **See the actual commands**: `mm --verbose`
2. **Build serially**: `mm --serial --verbose` (cleaner output)
3. **Check configuration**: `mm --show`
4. **Dry run**: `mm --dry` (shows what would happen)

### Q: Can I pass arguments to make?

Yes, everything after `mm` options goes to make:
```bash
mm some-target           # Build specific target
mm VERBOSE=1             # Make variable
mm --target=debug test   # Build tests in debug mode
```

## Projects & Dependencies

### Q: How do I link one library to another in the same project?

Use `prerequisites`:
```makefile
myproject.libraries := base.lib derived.lib

derived.lib.prerequisites := base.lib
derived.lib.extern := base.lib
```

### Q: How do I build Python extensions?

```makefile
myproject.libraries := mylib.lib
myproject.packages := myapp.pkg
myproject.extensions := myext.ext

myext.ext.stem := myext
myext.ext.pkg := myapp.pkg          # Install into this package
myext.ext.wraps := mylib.lib        # Link against this library
myext.ext.extern := mylib.lib python
```

### Q: Can I exclude specific source files?

Yes:
```makefile
mylib.lib.sources.exclude := \
    src/old_code.cc \
    src/broken.cc

mylib.lib.headers.exclude := \
    src/deprecated.h
```

### Q: How do I conditionally compile based on available dependencies?

```makefile
ifdef cuda.dir
    mylib.lib.extern += cuda
else
    mylib.lib.sources.exclude += gpu_solver.cu
endif
```

## Testing

### Q: How do I run tests?

```bash
mm test                  # Run all tests
mm test.mylib            # Run specific test suite
```

### Q: How do I set up tests?

For implicit tests (each source file is a test driver):
```makefile
myproject.tests := mylib.tests

mylib.tests.stem := mylib.tests
mylib.tests.extern := mylib.lib
mylib.tests.prerequisites := mylib.lib
```

For explicit test cases:
```makefile
tests.myapp.driver.cases := case1 case2 case3
case1.argv := --input test1.dat
case2.argv := --input test2.dat --verbose
```

## Advanced

### Q: How do I integrate with environment modules?

Create a modulefile:
```lua
setenv("mm_prefix", "/opt/myproject/gcc/opt")
setenv("mm_targets", "opt,shared")
prepend_path("PATH", pathJoin(os.getenv("mm_prefix"), "bin"))
prepend_path("PYTHONPATH", pathJoin(os.getenv("mm_prefix"), "packages"))
```

Or use mm's built-in support:
```bash
eval $(mm --paths=sh)      # Inject build env into shell
```

### Q: Can I use mm with Docker?

Yes, mm has docker-images support:
```makefile
myproject.docker-images := myapp.focal myapp.jammy

myapp.focal.name := focal-gcc-mm
myapp.jammy.name := jammy-gcc-mm
```

### Q: How do I build for multiple compilers/targets?

Use environment variables or modules:
```bash
# GCC debug
export mm_compiler=gcc mm_targets=debug
mm

# Clang optimized  
export mm_compiler=clang++ mm_targets=opt,shared
mm
```

Each combination gets its own build directory.

### Q: Can I override prefix and bldroot per invocation?

Yes:
```bash
mm --prefix=/tmp/test --bldroot=/tmp/build
```

Or via environment:
```bash
export mm_prefix=/tmp/test
export mm_bldroot=/tmp/build
mm
```

## Troubleshooting

### Q: mm says "GNU Make 4.2.1 or higher required"

Your make is too old. Install a newer version:
```bash
# Ubuntu/Debian
sudo apt install make

# Or install from source
wget https://ftp.gnu.org/gnu/make/make-4.4.tar.gz
```

### Q: mm can't find my project configuration

Make sure:
1. You have a `.mm/` directory in your project root
2. The file is named `.mm/{project}.mm` 
3. You're running mm from within the project tree

mm walks up from the current directory looking for `.mm/`.

### Q: My library isn't linking against dependencies

Make sure you specified `extern`:
```makefile
mylib.lib.extern := cuda mpi hdf5
```

Check that the dependencies are configured in `~/.mm/config.mm`.

### Q: Headers aren't being installed

By default, all `.h` files in `{library}.root` are installed.

If they're not, check:
1. Are they in subdirectories? Specify `{library}.directories`
2. Are they in `{library}.headers.exclude`?

### Q: Python package isn't importing

Check:
1. Is `products/packages/` in your `PYTHONPATH`?
2. Run: `eval $(mm --paths=sh)` to set up environment
3. Is the package actually installed? Check `products/packages/`

## Philosophy

### Q: Why not CMake/Autotools/SCons?

mm is **opinionated** and **convention-based**:
- No hand-written makefiles or CMakeLists.txt
- Auto-discovers sources (convention over configuration)
- Pre-configured for common dependencies
- Designed for scientific computing workflows

It trades flexibility for simplicity and speed.

### Q: When should I NOT use mm?

If you need:
- Windows native builds (mm is Unix/Linux focused)
- Non-standard project layouts mm doesn't support
- Build systems that are part of your API (e.g., header-only libraries with CMake configs)
- Complete control over every compiler flag for every file

### Q: Can I see the generated makefiles?

mm doesn't generate makefiles. It uses a library of makefile fragments in `{mm}/make/`.

To see what make does: `mm --verbose`

## Getting Help

### Q: Where can I find more examples?

- `examples/hello/` - Comprehensive multi-language project
- `examples/simple/` - Minimal examples
- `examples/prep/` - Test dependency examples

### Q: How do I report bugs or request features?

Open an issue at the [mm repository on GitHub](https://github.com/aivazis/mm).

### Q: Is there a community/mailing list?

See the [mm repository on GitHub](https://github.com/aivazis/mm) for discussions and contributions.
