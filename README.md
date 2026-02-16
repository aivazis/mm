# mm
A framework for building projects based on GNU make

## Installation

Install mm to a prefix of your choice:

```bash
./install.sh /path/to/prefix
```

For example, to install to `~/.local`:

```bash
./install.sh ~/.local
export PATH="$HOME/.local/bin:$PATH"
```

### Bash Completion (Optional)

mm supports tab completion for build targets and options. To enable it during installation:

```bash
./install.sh ~/.local --bash-completion
```

After installation, you may need to restart your shell or manually source the completion script:

```bash
source ~/.local/share/bash-completion/completions/mm
```

#### Development/Testing

If you're working on mm from source, you can test the completion without installing:

```bash
source bash-completion/mm
./mm <TAB>  # Now tab completion works
```

#### How It Works

The bash completion for mm provides:

- **Target completion**: Press TAB to see available make targets from your mm project
- **Option completion**: Complete mm command-line options (e.g., `--target`, `--prefix`)
- **Value completion**: Smart suggestions for option values (e.g., `--target=<TAB>` suggests debug, opt, shared, etc.)

The completion works by:
1. Detecting mm projects (directories with `.mm/` subdirectories)
2. Using `make -npq` to extract available targets from the makefile database
3. Filtering out internal/special targets to show only user-relevant targets

**Note**: Target completion requires that mm and its dependencies (pyre) are properly configured in your environment. If mm cannot run, the completion will fall back to common target names (all, clean, test, install, etc.).

## Usage

See the documentation in `docs/` for detailed usage information.

Quick start:

```bash
cd your-project
mm            # Build with default targets (debug, shared)
mm test       # Run tests
mm --target=opt,static  # Build optimized static variant
```
