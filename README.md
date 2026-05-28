# mm

A build orchestration framework for projects that mix C, C++, Fortran, CUDA,
and Python. You declare what you are building in one small configuration file;
mm discovers your sources and drives GNU make to compile, link, and install
everything in parallel.

## Requirements

- Python 3.10 or later (plus the [pyre](https://github.com/pyre/pyre) framework)
- GNU make 4.2.1 or later

## Installation

```bash
./install.sh ~/.local
export PATH="$HOME/.local/bin:$PATH"
```

Pass `--bash-completion` to also install tab-completion support for bash.

## Quick start

Create a `.mm/` directory at the root of your project and add a file named
after your project:

```makefile
# .mm/myproject.mm
# -*- Makefile -*-

myproject.libraries := mylib.lib

mylib.lib.stem := mylib
mylib.lib.root := lib/mylib/
mylib.lib.c++.flags += $($(compiler.c++).std.c++17)
```

Then run:

```bash
mm
```

mm walks up from the current directory to find `.mm/`, discovers all source
files under `lib/mylib/`, compiles them, and installs the results under
`products/`.

## Documentation

- `docs/` — guides, reference, and internals
- `examples/` — working projects of increasing complexity

## License

See `LICENSE`.
