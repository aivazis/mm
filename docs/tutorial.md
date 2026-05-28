# Building with mm — a step-by-step tutorial

This tutorial walks through building a small C++ library with Python bindings,
a command-line driver, and pyre framework integration. Each step introduces one
new concept and explains why it is designed the way it is. The complete source
for every step lives under `examples/step00` through `examples/step08`.

The project is called `timer`. It wraps `std::chrono::steady_clock` in a C++
library, exposes it to Python via a pybind11 extension, and provides a shell
utility that times the execution of any command.

---

## step00 — the project skeleton

A project tells mm what it is building through a `.mm/` directory at its root.
The top-level file is always `{project}.mm`. For a project named `timer` it is
`.mm/timer.mm`.

```makefile
# the project assets
timer.libraries := timer.lib

# load the library configuration
include $(timer.libraries)
```

Two things to notice. First, mm uses a flat namespace of dotted names for all
assets. `timer.lib` is just a name — mm will look for a configuration file
called `timer.lib` in the `.mm/` directory when you `include` it. Second, the
project file is only a manifest: it lists what exists and delegates detail to
per-asset files.

The library asset is declared in `.mm/timer.lib`:

```makefile
timer.lib.stem := timer
timer.lib.root := lib/timer/

timer.lib.extern :=

timer.lib.c++.flags += $($(compiler.c++).std.c++17)
```

`stem` controls the output file name (`libtimer.a` on most platforms). `root`
is the directory mm scans for source files — it discovers every `.cc` it finds
there automatically. `extern` is the list of external packages the library
needs; an empty list is explicit and intentional.

The `lib/timer/` directory follows a consistent layout. Every C++ namespace has:
- `forward.h` — forward declarations that shape the namespace
- `public.h` — includes all public headers in the directory
- one file trio per class: `Foo.h`, `Foo.icc`, `Foo.cc`

The sibling `lib/timer.h` simply includes `timer/public.h`, so clients write
`#include <timer.h>` and get everything.

---

## step01 — tests and version autogeneration

Step01 adds two things: a test suite and a generated version header.

```makefile
timer.libraries := timer.lib
timer.tests     := timer.lib.tests
```

Tests are their own asset type. The `.mm/timer.lib.tests` configuration names
the source directory and the library under test:

```makefile
timer.lib.tests.root   := tests/timer.lib/
timer.lib.tests.extern := timer.lib
```

Each `.cc` file under `tests/timer.lib/` becomes an independent test binary.
mm compiles and links them against `timer.lib`, places the executables in the
build tree, and wires them into the `test` target. Silence is pass; any output
signals a failure.

Version information is compiled into the library through a generated header.
The template `lib/timer/version.h.in` contains `@MAJOR@`, `@MINOR@`,
`@MICRO@`, and `@REVISION@` placeholders. mm substitutes them at build time
using the table in `.mm/timer.lib`:

```makefile
timer.lib.headers.autogen := version.h.in
timer.lib.autogen = \
    @MAJOR@|$(timer.major)    \
    @MINOR@|$(timer.minor)    \
    @MICRO@|$(timer.micro)    \
    @REVISION@|$(timer.revision)
```

The version variables (`timer.major` etc.) are extracted from the most recent
git tag that matches the project's version tag pattern. You edit
`version.h.in`; you never touch `version.h` directly.

---

## step02 — the Python package

Step02 adds `pkg/timer/`, a pure Python package that provides its own `Timer`
class backed by `time.perf_counter`.

```makefile
timer.packages := timer.pkg
timer.libraries := timer.lib
timer.tests     := timer.lib.tests timer.pkg.tests
```

The package asset needs almost no configuration:

```makefile
timer.pkg.stem := timer
```

`stem` is the installed package name. mm copies the contents of `pkg/timer/`
into the installation prefix, generates `meta.py` from `meta.py.in` (the same
substitution mechanism as `version.h.in`), and wires the package into
`PYTHONPATH` when you activate the build.

The Python `Timer` class lives in `pkg/timer/Timer.py` and `pkg/timer/__init__.py`
re-exports it:

```python
from .Timer import Timer
```

Python tests live in `tests/timer.pkg/` and are wired in via `timer.pkg.tests`.

---

## step03 — the pybind11 extension

Step03 wraps the C++ library so Python can call it directly. The extension is
declared in `.mm/timer.ext`:

```makefile
timer.ext.stem    := timer
timer.ext.wraps   := timer.lib
timer.ext.capsule :=
timer.ext.extern  := timer.lib pybind11 python

timer.ext.lib.c++.flags += $($(compiler.c++).std.c++17)
```

`wraps` tells mm which library this extension exposes, so it can generate the
correct include paths and link flags. `capsule` enables PyCapsule sharing
between extensions when they need to exchange C++ object pointers; an empty
value disables it. `timer.lib.c++.flags` does not automatically propagate to
the extension — the C++ standard flag must be repeated here because extension
binding files include the library headers and must be compiled at the same
standard level.

The extension source lives under `ext/timer/`. The entry point is
`ext/timer/__init__.cc`, which defines the pybind11 module:

```cpp
PYBIND11_MODULE(timer, m) {
    m.doc() = "the timer C++ extension module";
    timer::py::version(m);
    timer::py::Timer(m);
}
```

Each namespace directory has `__init__.h` and `__init__.cc` for module
initialisation plus one `Foo.cc` per bound class.

---

## step04 — the driver

Step04 adds `bin/timer`, a command-line script that times any shell command.

mm installs every executable file in `bin/` automatically — no configuration
entry is required. The script imports `Timer` with a fallback:

```python
try:
    from timer.ext import Timer
except ImportError:
    from timer import Timer
```

This pattern appears throughout the series. The extension is optional: if it is
not available (different Python version, different platform, the library wasn't
compiled), the pure Python implementation silently takes over. Users never see
the difference.

The driver uses `argparse` to accept `-n N` (run the command N times) and
prints statistics to stderr so timing output is separated from the timed
command's own stdout and stderr.

---

## step05 — pyre as a C++ dependency

Step05 introduces `pyre` as an external dependency of the C++ library.

`pyre` ships `journal`, a structured logging framework that works identically
in both C++ and Python. Adding it to the library is a one-line change in
`.mm/timer.lib`:

```makefile
timer.lib.extern := pyre
```

mm translates that name to the correct include paths, compile definitions, and
link flags by consulting `pyre`'s mm package descriptor. There is one
additional define that must be set explicitly:

```makefile
timer.lib.c++.defines += JOURNAL_DEBUG
```

Journal's `debug_t` channels compile to no-ops unless `JOURNAL_DEBUG` is
defined. This is intentional: debug logging is free in production builds. This
define is not inherited by any other asset even though the library lists `pyre`
in its extern — extern inheritance propagates the extern list itself (so
`timer.ext` gets `WITH_PYRE` and `WITH_JOURNAL`), but never compiler flags or
defines. The extension binding files do not use `debug_t`, so the extension
does not need `JOURNAL_DEBUG`.

Every `.cc` file in `lib/timer/` begins with:

```cpp
#include <portinfo>
```

`portinfo` is mm's answer to compiler and platform variation. It is generated
at build time from the detected toolchain and sets the macros your code needs
to handle differences across platforms without cluttering the source with
`#ifdef`.

With pyre available, `Timer.cc` can record lifecycle events:

```cpp
auto channel = pyre::journal::debug_t("timer.Timer");
channel << "start" << pyre::journal::endl;
```

Tests that use journal must initialise it correctly. The order matters:

```cpp
pyre::journal::application("timer.tests");  // must come first
pyre::journal::init(argc, argv);
```

`application` sets the program name that journal uses for channel lookups.
`init` then processes `--journal.*` command-line arguments. Getting the order
wrong is silent but produces confusing behaviour; checking against an existing
pyre project (`~/dv/qef`) is the fastest way to confirm the correct pattern.

---

## step06 — replacing argparse with `pyre.application`

Step06 rewrites the driver to use `pyre.application` instead of `argparse`.

```python
class App(pyre.application, family="timer.app"):
    """Time the execution of an arbitrary shell command."""

    count = pyre.properties.int(default=1)
    count.doc = "number of times to run the command"

    @pyre.export
    def main(self, *args, **kwds):
        command = list(self.argv)
        ...
        self.info.log(f"{samples[0]:.6f} s")
        return result.returncode
```

The differences from the argparse version are worth examining:

**Traits instead of argument definitions.** `count` is declared once as a
class-level descriptor. pyre wires it to `--count` on the command line, to
configuration files (`.pfg`, `.yaml`, `.ini`), and to the pyre configuration
store — all from that one declaration.

**`self.argv` instead of `REMAINDER`.** Positional arguments not consumed by
traits are available as `self.argv`. No `nargs=argparse.REMAINDER` required.

**Built-in channels.** `pyre.application` provides `self.info`, `self.warning`,
and `self.error` as pre-configured journal channels. No import of `journal`, no
channel construction. The application name is embedded in the channel name.

**`family` as the configuration key.** The string `"timer.app"` is how pyre
identifies this component in configuration files. A user can override any trait
in `~/.pyre/timer.pfg` using that dotted path.

The `family` and `implements` keyword arguments on the class declaration have
no counterpart in argparse — they are the foundation for the component system
explored in step07.

---

## step07 — protocols and components

Step07 introduces pyre's component model. The goal is to make the timer
implementation selectable at run time without changing any code.

### The protocol

`pkg/timer/protocols/Timer.py` declares what any timer must be able to do:

```python
class Timer(timer.protocol, family="timer.protocols.timer"):
    """The requirements for a wall-clock timer."""

    @timer.provides
    def start(self): ...

    @timer.provides
    def stop(self): ...

    @timer.provides
    def reset(self): ...
```

A protocol is a contract. `@timer.provides` marks an obligation. The protocol
also nominates its preferred implementation:

```python
@classmethod
def pyre_default(cls, **kwds):
    try:
        from timer.ext import CPP
        return CPP
    except ImportError:
        from timer import Timer
        return Timer
```

`pyre_default` runs at component resolution time. It selects the C++ backed
component when the extension is available and falls back to pure Python
otherwise — the same try/except pattern used since step04, now in one central
place.

### The components

`pkg/timer/Timer.py` is now a pyre component rather than a plain class:

```python
class Timer(
    timer.component, family="timer.timers.python", implements=timer.protocols.timer
):
    ...
    @timer.export
    def start(self) -> "Timer": ...
```

`implements` connects the component to its contract. `family` is its
registration key. `@timer.export` marks the methods that fulfil protocol
obligations.

`pkg/timer/ext/CPP.py` wraps the C++ extension object in the same pyre
component interface. Its `family` is `"timer.timers.cpp"`. The constructor
instantiates the raw C++ object and delegates all calls to it.

### The `clock` trait in the driver

The driver gains a `clock` trait:

```python
clock = timer.protocols.timer()
clock.doc = "the timer implementation to use"
```

Declaring a trait as a protocol instance tells pyre: this slot holds a
component that satisfies `timer.protocols.timer`. The default comes from
`pyre_default` — the C++ implementation when available, pure Python otherwise.

In `main`, the driver just calls the interface:

```python
clock = self.clock
clock.reset()
clock.start()
result = subprocess.run(command)
clock.stop()
```

The caller never knows whether `clock` is backed by C++ or Python.

### Switching the implementation at the command line

Here is the key demonstration of the component system. Run the driver with:

```
timer --timer.clock=timer.timers.python -- sleep 0.1
```

The `--timer.clock=timer.timers.python` argument tells pyre to use the pure
Python timer for this run, regardless of what `pyre_default` would select. No
code change, no recompile, no environment variable. The same override works in
a configuration file:

```ini
[timer.app]
clock = timer.timers.python
```

Or for the C++ backed version:

```
timer --timer.clock=timer.timers.cpp -- sleep 0.1
```

This is the component system's value proposition: the application's structure
is defined in code, but the wiring of its parts is deferred to configuration.
Users and test harnesses can substitute implementations without touching the
source.

---

## step08 — shell integration with `mm --activate` and `mm --branch`

Step08 shows how to integrate mm into a shell session so that `timer` (the
installed binary) and `import timer` (the installed package) are always
available without setting environment variables by hand.

### Activating a build

`mm --activate` emits shell export statements for PATH, PYTHONPATH, and a few
mm-internal variables. Because it emits rather than executes them, you wrap it
in `eval`:

```bash
mm.activate() {
    eval "$(mm --quiet --activate)"
}
```

`--quiet` suppresses the mm banner so only the export lines reach `eval`.
`mm.activate` is idempotent: it ejects the previous activation before injecting
the new one, so calling it twice is safe.

These must be shell *functions*, not aliases. `eval` inside a bash alias
executes in the wrong scope and the exports do not propagate to the calling
shell.

### Build paths

Without a branch tag, products land in:

```
builds/{target}/lib/
builds/{target}/bin/
```

and

```
products/{target}/lib/
products/{target}/bin/
```

where `{target}` encodes the platform and toolchain (e.g., `linux-gnu.x86_64`).

### Branch-scoped builds

`mm --branch=on` derives a tag from the current git state: `{project}/{branch}`,
then activates the corresponding installation tree. With a tag, the paths
become:

```
builds/{suite}/{project}/{branch}/{target}/
products/{suite}/{project}/{branch}/{target}/
```

where `{suite}` is the parent directory of the project root. The branch-tagged
build is completely isolated from the main build — you can switch between them
without rebuilding anything.

```bash
mm.branch() {
    eval "$(mm --quiet --branch=on)"
}
```

`mm --branch=off` clears the tag and returns to the unscoped installation tree.
The three functions in `etc/bash/activate.bash` are the complete interface:

```bash
mm.activate   # wire up the current mm installation
mm.branch     # switch to a branch-scoped build
mm.clear      # revert to the unscoped build
```

Source this file from `~/.bashrc` or `~/.bash_profile` to make the functions
available in every new shell. The file itself lives in `etc/bash/activate.bash`
inside the project, so it travels with the source tree and can be sourced with
a path relative to wherever you cloned it.

---

## What the steps demonstrate together

| Step | New concept |
|------|-------------|
| 00 | `.mm/` project skeleton; declarative asset declarations |
| 01 | C++ library; version header autogeneration; first tests |
| 02 | Python package; `meta.py.in` substitution |
| 03 | pybind11 extension; `wraps`; capsule control |
| 04 | Driver script; optional C++ fallback pattern |
| 05 | pyre as C++ extern; `portinfo`; journal channels; `JOURNAL_DEBUG` |
| 06 | `pyre.application`; traits; `self.argv`; built-in channels |
| 07 | Protocols and components; `pyre_default`; runtime implementation selection |
| 08 | `mm --activate`; `mm --branch`; branch-scoped build isolation |

The progression is deliberate. Steps 00–04 build a working tool with no
external dependencies beyond pybind11. Steps 05–07 add pyre incrementally,
each step showing one layer of the framework. Step08 closes the loop by showing
how the build system integrates with the development workflow.

# end of file
