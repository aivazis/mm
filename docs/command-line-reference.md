# mm Command-Line Reference

Complete reference for all mm command-line options and environment variables.

## Basic Usage

```bash
mm [options] [make-targets...]
```

Everything after mm options is passed directly to GNU Make.

## Quick Reference

### Most Common Options

```bash
mm                          # Build with defaults (debug, shared)
mm --target=opt             # Optimized build
mm --prefix=/opt/myproject  # Install to custom location
mm --verbose                # See all compiler commands
mm --show                   # Show make invocation
mm --paths=sh               # Export build environment
mm test                     # Run all tests
```

## Build Configuration Options

### `--project=<name>`

Set the project name. Normally this is set in your `.mm/{project}.mm` file.

**Type:** String  
**Default:** Inferred from directory name  
**Example:**
```bash
mm --project=myproject
```

### `--prefix=<path>`

Install location for build products.

**Type:** Path  
**Default:** `{project-root}/products`  
**Environment:** `mm_prefix`  
**Example:**
```bash
mm --prefix=/opt/myproject
mm --prefix=$HOME/local
```

Products installed to:
- `{prefix}/bin/` - Executables
- `{prefix}/lib/` - Libraries
- `{prefix}/include/` - Headers
- `{prefix}/packages/` - Python packages

### `--bldroot=<path>`

Location for intermediate build files (`.o`, `.d`, etc.).

**Type:** Path  
**Default:** `{project-root}/builds`  
**Environment:** `mm_bldroot`  
**Example:**
```bash
mm --bldroot=/tmp/builds
mm --bldroot=$HOME/tmp/myproject
```

### `--target=<variants>`

Build target variants (comma-separated).

**Type:** List of strings  
**Default:** `debug,shared`  
**Environment:** `mm_targets`  
**Available targets:**
- `debug` - Debug symbols, no optimization
- `opt` - Optimized (`-O3`)
- `shared` - Shared libraries (`.so`)
- ~~`static`~~ - **Not a built-in variant.** To build static-only, omit `shared` from `--target`.
- `prof` - Profiling enabled (`-pg`)
- `cov` - Coverage enabled (`--coverage`)
- `reldeb` - Release with debug info

**Examples:**
```bash
mm --target=opt              # Optimized only
mm --target=debug,shared     # Debug + shared (default)
mm --target=opt              # Optimized, static (no shared)
mm --target=opt,shared       # Optimized + shared
mm --target=prof,shared      # Profiling + shared
```

Each target combination gets its own directory: `builds/{variants}-{platform}-{arch}/`

## Build Behavior Options

### `--show`

Display the full make command that mm will invoke.

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --show
# Output: make: gmake --warn-undefined-variables --silent -j 16 ...
```

### `--dry`

Do everything except actually invoke make (dry run).

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --dry --show    # See what would be run
```

### `--verbose`

Show every command make executes (compiler invocations, etc.).

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --verbose
# Output shows:
# g++ -std=c++17 -O3 -c src/main.cc -o builds/.../main.o
# g++ -shared builds/.../main.o -o products/lib/libmylib.so
```

**Note:** Automatically forces `--serial` for readable output.

### `--quiet`

Suppress all non-critical output.

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --quiet    # Silent unless errors occur
```

### `--ignore`

Continue building even if some targets fail.

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --ignore    # Keep going despite failures
```

## Parallelism Options

### `--serial`

Build serially (one recipe at a time).

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --serial          # Single-threaded
mm --serial --verbose  # For debugging (clean output)
```

### `--slots=<N>`

Number of recipes to execute simultaneously.

**Type:** Integer  
**Default:** Number of CPU cores  
**Example:**
```bash
mm --slots=8     # Use 8 cores
mm --slots=1     # Same as --serial
mm -j 16         # Can also use make's -j syntax
```

## Advanced Options

### `--compilers=<list>`

Override the default compiler set.

**Type:** List of strings  
**Default:** System-dependent  
**Environment:** `mm_compilers`  
**Example:**
```bash
mm --compilers=gcc
mm --compilers="clang++,gfortran"
```

### `--make=<command>`

GNU make executable to use.

**Type:** String  
**Default:** `gmake` (or `$GNU_MAKE`)  
**Example:**
```bash
mm --make=make
mm --make=/usr/local/bin/gmake
```

### `--runcfg=<path>`

Additional directory to add to make's include path.

**Type:** String  
**Default:** Empty  
**Example:**
```bash
mm --runcfg=/path/to/extra/config
```

### `--cfgdir=<name>`

Name of project configuration directory.

**Type:** String  
**Default:** `.mm`  
**Example:**
```bash
mm --cfgdir=.build-config
```

### `--local=<filename>`

Name of local makefile to search for.

**Type:** String  
**Default:** `Make.mm`  
**Example:**
```bash
mm --local=Makefile
```

## Make Debug Options

### `--ruledb`

Ask make to print its rule database.

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --ruledb > rules.txt    # See all make rules
```

### `--trace`

Ask make to print trace information.

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --trace    # See make's decision process
```

## Environment Export Options

### `--paths=<shell>`

Generate shell commands to export build environment.

**Type:** String (one of: `sh`, `csh`, `fish`)  
**Default:** None  
**Example:**
```bash
# Bash/sh
eval $(mm --paths=sh)

# Csh/tcsh
eval `mm --paths=csh`

# Fish
eval (mm --paths=fish)
```

**What it sets:**
- `PATH` - Adds `{prefix}/bin`
- `PYTHONPATH` - Adds `{prefix}/packages`
- `MM_INCLUDES` - Sets to `{prefix}/include`
- `MM_LIBPATH` - Sets to `{prefix}/lib`

**Use cases:**
- Running binaries built by mm
- Importing Python packages built by mm
- Linking against libraries built by mm

### `--clear`

Remove mm paths from environment (used with `--paths`).

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
eval $(mm --paths=sh --clear)    # Remove mm from environment
```

## Display Options

### `--color`

Enable colorized output on supported terminals.

**Type:** Boolean  
**Default:** `true`  
**Example:**
```bash
mm --color=no     # Disable colors
mm --color=yes    # Enable colors (default)
```

### `--palette=<name>`

Color palette to use.

**Type:** String  
**Default:** `builtin`  
**Example:**
```bash
mm --palette=builtin    # Default palette
```

## Setup Options

### `--setup`

Initialize user configuration directory (`~/.mm/`).

**Type:** Boolean  
**Default:** `false`  
**Example:**
```bash
mm --setup    # Creates ~/.mm/config.mm with templates
```

Creates `~/.mm/config.mm` with commented-out configuration for common external packages.

## Environment Variables

mm can read configuration from environment variables. Command-line options override environment variables.

### Build Configuration

```bash
export mm_prefix="/opt/myproject"       # Install location
export mm_bldroot="/tmp/builds"         # Build staging area
export mm_targets="opt,shared"          # Build targets
export mm_compiler="gcc"                # Compiler choice
export mm_compilers="gcc,gfortran"      # Compiler set
```

### System Variables

```bash
export GNU_MAKE="gmake"                 # Make executable
export MPI_HOME="/usr/lib/openmpi"      # MPI location (used in configs)
```

### Module System Integration

For environment modules (Lmod, etc.):

```lua
-- myproject.lua
setenv("mm_system", "mm")
setenv("mm_abi", "opt-shared-linux-x86_64")
setenv("mm_target", "opt")
setenv("mm_compiler", "gcc")
setenv("mm_prefix", "/opt/myproject/gcc/opt")
setenv("mm_bldroot", "/tmp/builds/myproject")
setenv("mm_targets", "opt,shared")

prepend_path("PATH", "/opt/myproject/gcc/opt/bin")
prepend_path("PYTHONPATH", "/opt/myproject/gcc/opt/packages")
prepend_path("LD_LIBRARY_PATH", "/opt/myproject/gcc/opt/lib")
```

## Passing Arguments to Make

Everything after mm options is passed to make:

```bash
mm clean                    # Run 'make clean'
mm test                     # Run 'make test'
mm test.mylib              # Run specific test suite
mm install                 # Run 'make install'
mm -n                      # Make dry-run (show commands)
mm VERBOSE=1               # Set make variable
mm --target=opt clean all  # Clean then build with opt target
```

## Common Workflows

### Clean Build

```bash
rm -rf builds products
mm
```

### Debug Build

```bash
mm --target=debug --verbose --serial
```

### Optimized Release

```bash
mm --target=opt --prefix=/opt/myproject
```

### CI/CD Build

```bash
#!/bin/bash
export mm_prefix="/tmp/install"
export mm_bldroot="/tmp/build"
export mm_targets="opt"

mm clean
mm
mm test
```

### Multi-Compiler Build

```bash
# GCC debug
export mm_compiler=gcc
mm --target=debug --prefix=$HOME/gcc-debug

# Clang optimized
export mm_compiler=clang++
mm --target=opt --prefix=$HOME/clang-opt
```

### Development Workflow

```bash
# Initial build
mm

# Set up environment
eval $(mm --paths=sh)

# Use build products
python -c "import mypackage"
./products/bin/myapp

# Rebuild
mm

# Run tests
mm test

# Clean up environment when done
eval $(mm --paths=sh --clear)
```

## Runtime Target Help

mm provides built-in help through make targets:

```bash
mm --help                  # Show all command-line options
mm <project>.help          # List available targets for a project
mm <project>.info          # Show project configuration details
mm <asset>.info            # Show configuration for a library, package, etc.
mm builder.info.help       # List all info targets
mm host.info               # Show host platform details
```

## See Also

- [Quickstart Guide](quickstart.md) - Get building in 5 minutes
- [FAQ](FAQ.md) - Common questions and troubleshooting
- [Examples](examples.md) - Walkthrough of example projects
