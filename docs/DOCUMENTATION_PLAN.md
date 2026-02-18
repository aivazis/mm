# mm Documentation Plan

## Current Status

### Completed

1. **README.md** - Enhanced front page with quick start, feature highlights, and
   bash completion documentation.

2. **docs/quickstart.md** - Comprehensive guide covering installation,
   C++ library example, auto-discovery, Python packages/extensions, external
   dependencies, build targets, configuration hierarchy, host-specific config,
   environment variables, and shell integration.

3. **docs/FAQ.md** - 30+ common questions covering getting started,
   configuration, building, testing, advanced topics, and troubleshooting.

4. **docs/examples.md** - In-depth walkthrough of `examples/hello/` with
   project structure, build output, test setup, and conditional compilation.

5. **docs/command-line-reference.md** - Full option reference for mm.py v4.5
   (the current `mm.py` front-end).

6. **etc/bash_completion/mm** - Bash tab completion with dynamic target
   discovery, option completion, and inline help (merged in PR #29).

### Runtime Help

mm provides runtime help through make targets (no `--guide` flag exists):

```bash
mm --help              # Command-line options
mm <project>.help      # List available targets
mm <asset>.info        # Show asset configuration
mm builder.info.help   # List all info targets
mm host.info           # Host platform details
```

## Remaining Documentation Tasks

### Phase 2: Task-Oriented Guides (Priority: HIGH)

Create `docs/guides/` with:

1. **creating-a-library.md** - Single/multi-directory, header-only, static vs shared
2. **creating-a-python-package.md** - Pure Python, mixed Python/C++
3. **creating-an-extension.md** - C++ to Python bindings
4. **external-dependencies.md** - Pre-configured packages, custom packages
5. **tests-and-ci.md** - Test discovery, test cases, CI integration

### Phase 3: Reference Documentation (Priority: MEDIUM)

Create `docs/reference/` with:

1. **configuration-variables.md** - All project/asset/compiler variables
2. **build-targets.md** - Target variants with compiler flags per toolchain:
   - `debug` - `-g`, defines `DEBUG`
   - `opt` - `-O3`
   - `shared` - `-fPIC`, builds `.so`
   - `prof` - `-pg` profiling
   - `cov` - `--coverage` for gcov/lcov
   - `reldeb` - `-g -O`, release with debug info
   - Note: `static` is not a built-in variant; omit `shared` to get static-only
3. **external-packages.md** - Complete list of pre-configured extern packages
4. **supported-languages.md** - C, C++, Fortran, CUDA, Python, Cython, JavaScript

### Phase 4: Architecture & Extension (Priority: LOW)

1. **design-philosophy.md** - Why Python + Make, convention over configuration
2. **python-make-boundary.md** - What Python vs Make each handle
3. **makefile-organization.md** - The make fragment library explained
4. **adding-new-languages.md** - Language support checklist

### Notes

- mm has two Python front-ends: `mm.py` (v4.5.0, 1097 lines) and `mm`
  (v5.0.0, 1316 lines). Current docs cover `mm.py`. The v5 `mm` adds
  `--pkgdb`, `--version`, `--bin-prefix`, `--lib-prefix`, and renames
  `--ruledb` to `--rules`.
- `examples/prep/` contains test dependency examples (not preprocessing).
- `examples/simple/` uses a minimal include-based pattern.

## Documentation Style Guide

### Principles
1. **Show, don't tell** - Working examples over theory
2. **Progressive disclosure** - Simple first, complexity later
3. **Copy-paste ready** - All examples should be executable
4. **Real-world** - Use patterns from actual projects
5. **Concise** - Respect the reader's time

### Format
- Use shell code blocks for commands
- Use `makefile` syntax highlighting for .mm files
- Include expected output where helpful
- Always show the "why" not just the "how"

## Success Metrics

Documentation is successful when:
1. New user can build first project in <5 minutes
2. Common tasks don't require reading source code
3. Users can find answers via grep/search
4. Examples cover 80% of real use cases
