# mm — Command-line Reference

Every option here can also be set in `.mm/mm.yaml` under the `mm:` key (see
the FAQ for the config file format). Command-line values take precedence over
the config file.

Options are grouped below by how often you are likely to need them. The
built-in help (`mm --help`) lists all options alphabetically — use this page
to find what you are looking for first.

---

## Common options

These are the options most users reach for regularly.

### Build location

`--mode=dev|release|conda|macports|ubuntu`
: Strategy for resolving where build products land — and, more broadly, the
  deployment intent that the make layer can vary behavior on (see
  [Build Modes](modes.md)). `dev` (default) puts intermediates in `builds/` and
  installed products in `products/` relative to the project root — fine for
  getting started, but set `bldroot` and `prefix` to locations outside the
  source tree for anything serious. `release` is a local production-style build
  that mirrors `dev` but lands under its own `release/` discriminator so its
  artifacts never mix with dev ones. `conda`, `macports`, and `ubuntu` resolve
  the prefix automatically from the package manager.

`--bldroot=PATH`
: Override the directory for intermediate build products (object files,
  dependency files). Overrides the mode default.

`--prefix=PATH`
: Override the installation directory. Overrides the mode default.

### What to build

`--target=VARIANT[,VARIANT...]`
: One or more build variants to activate. The default is `debug,shared`.
  Common values: `debug`, `opt`, `shared`, `static`, `coverage`. Each variant
  combination lands in its own subdirectory of `bldroot`, so multiple targets
  co-exist.

`--compilers=NAME[,NAME...]`
: The compiler suite(s) to use, e.g. `clang,python/python3` or
  `gcc,python/python3`. The first C/C++ compiler in the list determines the
  ABI tag used in build paths.

### Parallelism

`--slots=N` (aliases: `-j`, `--jobs`)
: Number of make recipes to run simultaneously. Defaults to all available cores.

`--serial`
: Run make single-threaded. Equivalent to `--slots=1`.

### Shell session integration

`--activate`
: Emit shell export statements that prepend the build's `bin/` to `PATH` and
  its Python package directory to `PYTHONPATH`. Wrap in `eval "$(mm --quiet
  --activate)"` inside a shell function. Safe to call repeatedly — ejects the
  previous activation first.

`--branch=on|off`
: `on`: derive a build tag from the current git branch and activate the
  corresponding build context. `off`: clear the tag and return to the untagged
  context. Emit with `eval "$(mm --quiet --branch=on)"`.

`--syntax=sh|csh|fish`
: Shell syntax for the export statements emitted by `--activate` and `--branch`.
  Default: `sh`.

### Package database

`--setup`
: Instead of building, scan the system package manager and write a package
  database to the build root. Use this once on a new machine or after installing
  packages. Requires `--pkgdb`.

`--pkgdb=adhoc|conda|macports|dpkg`
: Package manager to use for `--setup`. `adhoc` (default) populates the
  database from explicit path settings in your mm config files; the others
  query the package manager directly.

### Diagnostics

`--dry` (alias: `-n`)
: Do everything except invoke make — print what would happen.

`--show`
: Print the full make command line before running it.

`--quiet` (alias: `-q`)
: Suppress the mm banner and all non-critical output. Use with `--activate` so
  only the export lines reach `eval`.

---

## Advanced options

These options come up in less common but fully supported workflows.

### Make behaviour

`--verbose` (alias: `-v`)
: Pass `--verbose` to make. Prints every compiler and linker invocation as it
  runs.

`--ignore` (alias: `-k`)
: Pass `--keep-going` to make. Continue building other targets after a failure.

### Build discrimination

`--tag=STRING`
: Set a discriminator tag directly, appended to `bldroot` and `prefix` to
  separate build contexts. `--branch=on` derives this automatically from git;
  `--tag` sets it explicitly.

`--environment=NAME`
: Name of the conda environment. Defaults to the value of
  `$CONDA_DEFAULT_ENV`. Used by `--mode=conda` to find the environment prefix.

### Installation layout

The following options set the subdirectory under `prefix` for each asset type.
The defaults are almost always correct; override them only when installing into
a prefix with a non-standard layout (e.g. Debian's `dist-packages` path, or a
conda environment with a versioned site-packages).

`--python-prefix=PATH` (trait: `pycPrefix`)
: Python package installation directory, relative to `prefix`. Default:
  `packages`.

`--bin-prefix=PATH`, `--lib-prefix=PATH`, `--include-prefix=PATH`,
`--doc-prefix=PATH`, `--etc-prefix=PATH`, `--share-prefix=PATH`,
`--var-prefix=PATH`
: Installation subdirectory for executables, libraries, headers, documentation,
  system auxiliary files, platform-independent data, and runtime files,
  respectively.

### Miscellaneous

`--local=NAME`
: Name of an optional local makefile in the project tree that adds extra
  targets or overrides. mm loads it alongside the standard build rules.

`--runcfg=PATH[,PATH...]`
: Additional paths to add to make's include path. Useful for injecting
  site-specific make fragments without modifying the project configuration.

`--toolchains=PATH` (trait: `toolchains`)
: Root directory for environment-level developer toolchains (e.g. playwright).
  Defaults to `~/tools/mm/$CONDA_DEFAULT_ENV/toolchains`, keyed by the active
  environment so a toolchain is shared across every build context rather than
  tied to a build variant. See *Developer toolchains* in the README.

`--color=yes|no`
: Enable or disable colorised output. Default: `yes` on terminals that support
  it.

`--version=STRING`
: Override the project version string. mm normally extracts the version from
  the most recent matching git tag.

---

## Esoteric options

These options exist for situations where the standard installation is unusual
or broken. They are marked `caveat emptor` in the built-in help for good
reason — incorrect values will silently produce a non-functional build.

`--cfgdir=PATH`
: The name of the directory mm looks for at the project root. Default: `.mm`.
  Change this only if the project uses a non-standard configuration directory.

`--make=PATH`
: Path to the GNU make executable. Default: `gmake` on macOS, `make`
  elsewhere. Override via the `GNU_MAKE` environment variable or this option.

`--engine=PATH`
: Path to the directory containing mm's built-in make fragments. Normally
  resolved automatically from the mm installation.

`--portinfo=PATH`
: Directory containing mm's built-in `portinfo` headers. Normally resolved
  automatically.

`--merlin=NAME`
: Name of the top-level internal makefile entry point. Default: `merlin.mm`.

`--rules`
: Ask make to print its full rule database before building.

`--trace`
: Ask make to print a trace of every rule it considers.

`--palette=NAME`
: Color palette name for terminal output. Default: `builtin`.

# end of file
