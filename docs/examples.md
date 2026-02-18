# mm Examples Walkthrough

This guide provides an in-depth tour of mm's example projects, showing real-world usage patterns.

## The Hello Example: A Complete Multi-Language Project

The `examples/hello/` project demonstrates mm's full capabilities in a single, well-organized example.

### Project Structure

```
examples/hello/
├── .mm/
│   └── hello.mm          # Project configuration
├── lib/hello/            # C++ library sources
│   ├── hello.h           # Main header
│   ├── greetings/        # Greetings subsystem
│   │   ├── hello.h
│   │   ├── hello.cc      # C++ implementation
│   │   ├── goodbye.h
│   │   └── goodbye.cc
│   └── friends/          # Multi-language implementations
│       ├── alec.h, alec.cc     # C++
│       ├── ally.h, ally.cc     # C++
│       ├── mac.h, mac.c        # C
│       └── mat.h, mat.f03      # Fortran
├── pkg/hello/            # Python package
│   ├── __init__.py
│   ├── cli/              # Command-line interface
│   └── shells/           # Application shells
├── ext/hello/            # Python C++ extension
│   ├── hello.cc          # Main module
│   ├── greetings.cc      # Bindings for greetings
│   └── friends.cc        # Bindings for friends
├── bin/
│   └── say               # Executable driver script
├── tests/
│   ├── hello.lib/        # C++ library tests
│   │   ├── say-hello.cc
│   │   └── say-goodbye.cc
│   └── hello.pkg/        # Python package tests
│       ├── sanity.py
│       └── say.py
└── etc/
    └── bash_completions/ # Shell completions
```

### What This Project Builds

From this single directory structure, mm produces:

1. **C++ Library**: `libhello.so`
   - Links against: `pyre`
   - Compiled from: all `.cc`, `.c`, `.f03` files in `lib/hello/`
   - Installs to: `products/lib/libhello.so`

2. **Headers**: Complete directory structure preserved
   - Installs to: `products/include/hello/`
   - All `.h` files, preserving subdirectories

3. **Python Package**: `hello`
   - All `.py` files from `pkg/hello/`
   - Installs to: `products/packages/hello/`

4. **Python Extension**: `hello.so`
   - C++ extension wrapping `libhello`
   - Installs to: `products/packages/hello/hello.so`
   - Importable as: `from hello import hello`

5. **Executable**: `say`
   - Command-line tool
   - Installs to: `products/bin/say`

6. **Test Suites**:
   - C++ tests: `test.hello.lib.*`
   - Python tests: `test.hello.pkg.*`

### Building the Example

```bash
cd examples/hello

# Build everything (uses all CPU cores by default)
mm

# Output shows:
# Compiling: lib/hello/greetings/hello.cc
# Compiling: lib/hello/greetings/goodbye.cc
# Compiling: lib/hello/friends/alec.cc (C++)
# Compiling: lib/hello/friends/ally.cc (C++)
# Compiling: lib/hello/friends/mac.c (C)
# Compiling: lib/hello/friends/mat.f03 (Fortran)
# Linking: products/lib/libhello.so
# Installing: Python package hello
# Compiling: ext/hello/hello.cc
# Linking: products/packages/hello/hello.so
# Installing: products/bin/say
```

### Using the Build Products

```bash
# Set up environment to use the products
eval $(mm --paths=sh)

# Use the command-line tool
say hello alec
# Output: Hello, Alec!

say goodbye mat
# Output: Goodbye, Matthias!

# Use from Python
python << EOF
import hello
print(hello.greet())  # Uses C++ extension
EOF
# Output: hello

# Check what was built
ls products/lib/         # libhello.so
ls products/include/     # hello/ directory tree
ls products/packages/    # hello/ Python package
ls products/bin/         # say executable
```

### Running Tests

```bash
# Run all tests
mm test

# Run specific test suites
mm test.hello.lib        # C++ library tests only
mm test.hello.pkg        # Python package tests only

# Run specific test cases
mm test.hello.lib.say-hello
mm test.hello.pkg.say.hello.alec
```

### Key Configuration Patterns

Let's break down the `.mm/hello.mm` configuration (which is now heavily annotated):

#### 1. Multi-Language Library

```makefile
# Declare the library
hello.libraries := hello.lib

# Configure it
hello.lib.stem := hello
hello.lib.extern := pyre
hello.lib.c++.flags += $($(compiler.c++).std.c++17)
```

**What happens:**
- mm scans `lib/hello/` for ALL source files
- Finds: `.cc` (C++), `.c` (C), `.f03` (Fortran)
- Compiles each with appropriate compiler
- Links into single `libhello.so`
- Installs all `.h` files preserving structure

#### 2. Python Package with Drivers

```makefile
# Declare the package
hello.packages := hello.pkg

# Configure it
hello.pkg.stem := hello
hello.pkg.drivers := say
```

**What happens:**
- mm copies all `.py` files from `pkg/hello/` to `products/packages/hello/`
- Finds `bin/say` and installs to `products/bin/say` (executable)
- Package is importable via `PYTHONPATH`

#### 3. Python Extension Wrapping C++

```makefile
# Declare the extension
hello.extensions := hello.ext

# Configure it
hello.ext.stem := hello
hello.ext.pkg := hello.pkg          # Install INTO this package
hello.ext.wraps := hello.lib        # Link AGAINST this library
hello.ext.extern := hello.lib pyre python
```

**What happens:**
- mm compiles extension sources from `ext/hello/`
- Links against `libhello.so` and Python libraries
- Installs to `products/packages/hello/hello.so`
- Python can import: `from hello import hello` (the extension module)

#### 4. Implicit Test Discovery

```makefile
# C++ tests
hello.tests.hello.lib.stem := hello.lib
hello.tests.hello.lib.extern := hello.lib pyre
hello.tests.hello.lib.prerequisites := hello.lib
```

**What happens:**
- mm finds ALL `.cc` files in `tests/hello.lib/`
- Compiles each as standalone test executable
- Runs each executable
- Exit code 0 = pass, non-zero = fail

No explicit test case list needed!

#### 5. Explicit Test Cases

```makefile
# Python tests with arguments
tests.hello.pkg.say.cases := say.hello.alec say.hello.mac

say.hello.alec.argv := hello alec
say.hello.mac.argv := hello mac
```

**What happens:**
- mm runs: `python tests/hello.pkg/say.py hello alec`
- mm runs: `python tests/hello.pkg/say.py hello mac`
- Captures output and checks exit codes

### Auto-Discovery in Action

The power of mm is that **most of the configuration** is implicit:

#### Library Discovery
```makefile
hello.lib.stem := hello
# Implicitly:
# hello.lib.root := lib/hello/
# hello.lib.directories := <all subdirs recursively>
# hello.lib.sources := <all .cc, .c, .f files>
# hello.lib.headers := <all .h files>
```

#### Package Discovery
```makefile
hello.pkg.stem := hello
# Implicitly:
# hello.pkg.root := pkg/hello/
# Copies entire directory tree to products/packages/hello/
```

#### Test Discovery
```makefile
hello.tests.hello.lib.stem := hello.lib
# Implicitly:
# Finds ALL .cc files in tests/hello.lib/
# Each becomes a test case
```

### Conditional Compilation Example

While not used in hello, here's how you'd add conditional features:

```makefile
# In .mm/hello.mm, add:
ifdef cuda.dir
    hello.lib.extern += cuda
    hello.lib.cuda.flags += -allow-unsupported-compiler
else
    # Exclude GPU implementations
    hello.lib.sources.exclude += lib/hello/gpu/gpu_greet.cu
endif

ifdef hdf5.dir
    hello.lib.extern += hdf5
else
    hello.lib.sources.exclude += lib/hello/io/hdf5_writer.cc
endif
```

This enables features based on what's available in `~/.mm/config.mm`.

## Other Examples

### examples/simple/

Minimal examples showing basic patterns. Good for:
- Quick reference
- Copy-paste starting points
- Understanding minimal configuration

### examples/prep/

Test dependency examples showing how projects declare test prerequisites.

## Building Your Own Project Based on Hello

### Step 1: Copy the Structure

```bash
# Start with hello's layout
mkdir myproject
cd myproject
mkdir -p .mm lib/mylib pkg/mypkg ext/myext tests/mylib.lib tests/mypkg.pkg bin

# Copy and adapt the configuration
cp examples/hello/.mm/hello.mm .mm/myproject.mm
```

### Step 2: Adapt the Configuration

Edit `.mm/myproject.mm`:

```makefile
# -*- Makefile -*-

# Declare what you're building
myproject.libraries := mylib.lib
myproject.packages := mypkg.pkg
myproject.extensions := myext.ext

# Library
mylib.lib.stem := mylib
mylib.lib.extern := pyre          # Your dependencies here
mylib.lib.c++.flags := $($(compiler.c++).std.c++20)

# Package
mypkg.pkg.stem := mypkg
mypkg.pkg.drivers := myapp

# Extension
myext.ext.stem := myext
myext.ext.pkg := mypkg.pkg
myext.ext.wraps := mylib.lib
myext.ext.extern := mylib.lib pyre python
```

### Step 3: Add Your Code

```bash
# Add library sources
cat > lib/mylib/mylib.h << 'EOF'
#pragma once
const char* greet();
EOF

cat > lib/mylib/mylib.cc << 'EOF'
#include "mylib.h"
const char* greet() { return "Hello from mylib!"; }
EOF

# Add Python code
cat > pkg/mypkg/__init__.py << 'EOF'
def hello():
    print("Hello from Python!")
EOF
```

### Step 4: Build

```bash
mm
```

That's it!

## Tips for Large Projects

### 1. Organize by Subsystem

```
lib/mylib/
  core/           # Core functionality
  geometry/       # Geometry subsystem
  physics/        # Physics subsystem
  io/             # I/O subsystem
```

mm automatically discovers everything.

### 2. Use Separate Config Files

For very large projects, split configuration:

```makefile
# .mm/myproject.mm
include libmylib.dirs
include libmylib.exclusions
include libmylib.tests

mylib.lib.directories := \
    ${addprefix $(mylib.lib.root),$(libmylib.srcdirs)}
```

See `sumMIT` project for real-world example of this pattern.

### 3. Separate Build Variants

```bash
# Debug build
mm --target=debug

# Optimized build
mm --target=opt

# Profiling build
mm --target=prof
```

Each gets its own directory in `builds/`.

### 4. Document Your Configuration

Add comments explaining non-obvious choices:

```makefile
# Link against MPI for parallel operations
mylib.lib.extern += mpi

# Disable AVX on older machines
# mylib.lib.c++.flags += -mno-avx
```

## Summary

The hello example shows that with mm, you can:

1. **Build complex multi-language projects** with minimal configuration
2. **Let directory structure** drive the build
3. **Auto-discover** sources, tests, and dependencies
4. **Mix languages** seamlessly (C, C++, Fortran in same library)
5. **Create Python extensions** with simple declarations
6. **Test everything** with implicit + explicit test discovery

The key insight: **mm doesn't need explicit file lists**. Organize your code well, declare what you're building, and let mm handle the details.

See `examples/hello/.mm/hello.mm` for the complete configuration.
