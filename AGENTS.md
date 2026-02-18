# Repository Guidelines

## Project Structure & Module Organization
`mm` and `mm.py` host the Python front-end that inspects a project and invokes GNU Make. Platform, language, and library presets live in `make/` (e.g., `make/compilers/intel.mm`). Headers sit in `include/mm/`, docs in `docs/`, and samples in `examples/`. Each sample mirrors real deployments: `.mm/{project}.mm` declares the build graph, `lib/` and `pkg/` store C++/Python sources, and `tests/` hold integration checks.

## Build, Test, and Development Commands
- `./install.sh ~/.local && export PATH="$HOME/.local/bin:$PATH"` bootstraps a user install for local testing.
- `./mm --help` shows all command-line options; `mm <project>.help` and `mm <asset>.info` provide runtime target information.
- `./mm --target=opt,static --show` exercises optimized/static variants and shows the generated make line.
- `./mm --prefix=/tmp/mm-dev products` writes artifacts into a scratch prefix before publishing.
- `./mm test` or `./mm test hello.pkg --target=cov` runs all tests or a focused suite with coverage objects.

## Coding Style & Naming Conventions
Python sources (`mm.py`, `examples/hello/pkg/`) follow PEP 8: four-space indents, descriptive snake_case, f-strings, and module docstrings outlining CLI verbs. C++/Fortran samples under `examples/hello/lib/hello` use `.cc/.h`, four-space blocks, directory-mirroring namespaces (e.g., `hello::greetings`), STL types, and `static` helpers for internal linkage. Make fragments rely on lowercase, dot-delimited identifiers (`component.kind.setting := value`) and `:=` assignments; keep new knobs consistent.

## Testing Guidelines
Scenario tests live beside their feature (`examples/hello/tests`, `make/tests`). Follow the `component.variant` naming pattern (`hello.lib`, `hello.pkg`) and keep fixtures tiny so they run in seconds. Always run `./mm test` before opening a PR, paste the command in the description, and prefer `./mm test --target=cov` when touching discovery or planner code. Toolchain updates should include a smoke target in `examples/prep` that proves the new compiler or flag set.

## Commit & Pull Request Guidelines
Git history favors short, imperative summaries (`added intel compilers`, `removed c++20 as default`). Keep subjects under 72 characters, elaborate below when context is subtle, and optionally prefix scope (`docs:`, `examples:`). PRs need a problem statement, brief change bullets, the `./mm test` command you ran, linked issues, and screenshots/logs for user-visible changes. Tag maintainers for the impacted subsystem and wait for one passing run plus a maintainer approval before merging.

## Configuration Tips
mm derives everything from `.mm/{project}.mm`. Use `mylib.lib.root := lib/mylib/` style assignments, keep secrets out of configs, and prefer environment overrides (`mm_prefix`, `mm_targets`) instead of editing tracked files for personal setups. When sharing new presets, document external toolchains in `docs/` and gate optional features behind `ifdef <dependency>.dir` blocks so default builds stay portable.
