# Adding support for an external package

An **external** is a third-party library or tool that your code compiles and
links against — HDF5, MPI, GSL, pybind11, and so on. mm models each one as a
small declarative file that says where its headers and libraries live and what
else it needs. Assets opt in by listing the package in their `.extern`:

```makefile
qed.lib.extern := journal.lib hdf5 gsl
```

Package definitions live under `make/extern/<pkg>/`, and may be overridden or
added to from two more locations (see [Where definitions live](#where-definitions-live)).
This guide walks through writing one.

---

## The mental model: four tiers

An asset's `.extern` is a starting point, not the final word. mm refines it
through four tiers:

1. **declared** — the raw `.extern` list the asset's author wrote.
2. **requested** — the transitive closure of that list, following each package's
   `.dependencies` (so a parallel `hdf5` drags in `mpi` without anyone asking).
3. **supported** — the requested packages mm actually has a definition for.
4. **available** — the supported packages that are actually **installed**.

A package is *available* when **`<pkg>.dir` resolves to a real directory**. That
variable is the install prefix; it is set by the user, the active configuration,
or the package database — **never inside `init.mm`**. (A few special packages —
`fortran` — set `<pkg>.self := true` instead, because they have no install root.)

Everything below is about writing the definition that feeds tiers 2–4.

---

## Anatomy of `init.mm`

Here is the whole of `make/extern/proj/init.mm` — the minimal, no-surprises
template. Copy a neighbour and change the names:

```makefile
# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# add me to the pile
extern += ${if ${filter proj,$(extern)},,proj}

# find my configuration file
proj.config := ${dir ${call extern.config,proj}}

# compiler flags
proj.flags ?=
# enable {proj} aware code
proj.defines := WITH_PROJ
# the canonical form of the include directory
proj.incpath ?= $(proj.dir)/include
# header marker(s): files that must resolve on {incpath}; absence proves breakage
proj.markers.headers ?= proj.h

# linker flags
proj.ldflags ?=
# the canonical form of the lib directory
proj.libpath ?= $(proj.dir)/lib
# its rpath
proj.rpath = $(proj.libpath)
# the names of the libraries
proj.libraries := proj

# my dependencies
proj.dependencies =


# end of file
```

Field by field:

| Variable | Purpose |
|---|---|
| `extern += …` | register the package, idempotently |
| `<pkg>.config` | locate this file's directory |
| `<pkg>.flags` | extra compiler flags |
| `<pkg>.defines` | preprocessor macros that enable package-aware code |
| `<pkg>.incpath` | include search path(s) — usually `$(<pkg>.dir)/include` |
| `<pkg>.markers.headers` | headers that **must** resolve on `incpath` (see [Markers](#verification-markers)) |
| `<pkg>.ldflags` | extra linker flags |
| `<pkg>.libpath` | library search path(s) |
| `<pkg>.rpath` | runtime library path baked into the binary |
| `<pkg>.libraries` | the libraries to link (`foo` → `-lfoo`) |
| `<pkg>.dependencies` | other externals this one needs (see [Dependencies](#declaring-dependencies)) |

**Use `?=` for anything a user might override** (paths, flags, flavors) so an
ad-hoc config can change it. Use `:=` only for values you compute internally and
own outright. A header-only package leaves `libpath`/`libraries` empty; that is
fine and is *not* a misconfiguration.

---

## Declaring dependencies

`<pkg>.dependencies` is **load-bearing**: it lists other externals this package
needs, and mm follows it transitively. When an asset lists your package, every
package in your dependency closure is loaded and contributes its include/link
options automatically — the consumer never has to know.

Most packages have a static list, or none:

```makefile
parmetis.dependencies = metis
```

### Induced (conditional) dependencies

A dependency can be **induced** by the package's own configuration. The canonical
case is a parallel HDF5, which must link against MPI. The knowledge lives in
`hdf5/init.mm`, where it belongs:

```makefile
hdf5.parallel ?= off
…
hdf5.dependencies = ${if ${findstring mpi,$(hdf5.parallel)},mpi}
```

Two things make this work:

- **Lazy assignment (`=`, not `:=`).** The edge is evaluated when the closure is
  walked, by which point `hdf5.parallel` has its effective value — whether the
  default here, a user override, or a value detected by the package database.
- **mm follows the edge at load time.** The loader reads `init.mm` first, *then*
  descends into `.dependencies`, so an induced edge is already defined when mm
  reaches it.

The result: a consumer writes `…​.extern := … hdf5`, and `mpi` appears on the
compile and link lines if and only if HDF5 is parallel. No consumer ever mentions
`mpi`.

A dependency may also be chosen at load time:

```makefile
# gsl: use the configured blas if it is a known external, else fall back to gslcblas
gsl.blas ?=
${if ${call extern.exists,$(gsl.blas)}, \
    ${eval gsl.dependencies = $(gsl.blas)}, \
    ${eval gsl.libraries += gslcblas}}
```

> A dependency should name another **supported** external. Anything mm cannot
> resolve is simply dropped from the closure.

---

## Verification markers

Markers are how mm proves a package is actually usable, rather than merely
declared. There are three kinds.

- **`<pkg>.markers.headers`** — header files that must exist somewhere on
  `incpath`. If one is missing, the package cannot be compiled against.
- **Libraries** are checked implicitly: every name in `<pkg>.libraries` is probed
  on `libpath` as `lib<name>.{so,dylib,a}`. A name that resolves to no file is a
  broken library.
- **`<pkg>.markers.required`** — names of variables that **must come out
  non-empty**. This is the subtle one.

### When to declare `markers.required`

> **Rule of thumb:** declare `markers.required` only for a value that is
> **conditionally computed** and could legitimately come out empty from a
> misconfiguration. Never declare it for a fixed constant — that check can never
> fire and only adds noise.

The value of the marker is the loud, self-describing warning you get *at load
time* instead of an opaque link failure much later. Pair it with an optional
`<pkg>.markers.required.hint` that names the likely cause and fix:

```makefile
# mpi: an unrecognized flavor leaves {libraries} empty and the link silently
# drops the mpi symbols
mpi.markers.required ?= libraries
mpi.markers.required.hint ?= "(mpi.flavor='$(mpi.flavor)' unrecognized; expected openmpi or mpich)"
```

By contrast, a package whose `libraries := proj` is a constant should **not**
declare it required — there is no way for `proj.libraries` to be empty.

**Quote any hint text**; the message passes through mm's logging, and an unquoted
`:` or other token can be misread.

---

## Flavor- and mode-driven libraries

Several packages compute `libraries` (and sometimes `dependencies`) from a
user-set knob. This is the pattern behind most `markers.required` declarations:

| Package | Knob | What it drives |
|---|---|---|
| `mpi` | `mpi.flavor` (`openmpi` / `mpich`) | the set of MPI libraries |
| `fftw` | `fftw.flavor` (`3`, `3f`, `3_threads`, …) | `fftw3`, `fftw3f`, … |
| `vtk` | `vtk.required` (module list) | `vtk<module>-<version>` |
| `hdf5` | `hdf5.parallel` | the induced `mpi` dependency |

The shape is always: a knob with a sensible `?=` default, a derived `libraries`
or `dependencies`, and a `markers.required` so a bad knob surfaces loudly rather
than failing at link time.

---

## Installed vs declared, and the warning you may see

Because availability hinges on `<pkg>.dir`, intent and reality can disagree.
Saying "I want a parallel HDF5" (`hdf5.parallel := mpi`) is one thing; having an
MPI installation to link against is another.

When a package is pulled into the closure but has **no install**, mm drops it
from the *available* tier and — if it was **induced** rather than declared
directly — emits a complaint naming the chain:

```
extern qed.lib: induced dependency 'mpi' is not installed (no <pkg>.dir); the link will likely fail
```

By default this is a **warning** and the build proceeds, letting the real
authority — the compiler or linker — be the one to fail. The severity is a single
knob:

```makefile
# warning (default) — keep going; flip to error to fail early
extern.complain.severity := error
```

`mm <pkg>.verify` audits the configuration on its own and is never silenced by
this knob.

---

## Checking your work

Three targets, increasing in focus:

- **`mm extern.info`** — the lay of the land: definition locations, and the
  supported / available / requested / provided sets.
- **`mm <pkg>.verify`** — the per-package report: `incpath`, header markers and
  whether they resolve, `libpath`, libraries and whether they resolve, any unset
  required values, and the package's dependencies and whether they are available.
- **`mm extern.verify`** — every external the project loads, split into a
  *verified* set and a *broken* set.

A healthy `mm hdf5.verify` reports `headers ok`, `libraries ok`, and (for a
parallel build with MPI installed) `dependencies ok`.

---

## Checklist

- [ ] `make/extern/<pkg>/init.mm` with the standard header and `# end of file`.
- [ ] `extern += …` to register; `<pkg>.config` to locate.
- [ ] `incpath` + `markers.headers`; `libpath` + `libraries` (or empty, for
      header-only).
- [ ] `defines` for any `WITH_<PKG>` macros your code keys off.
- [ ] `dependencies` — static, induced, or empty.
- [ ] `markers.required` **only** for a conditionally computed critical value,
      with a quoted hint.
- [ ] `?=` for anything a user should be able to override.
- [ ] `mm <pkg>.verify` is clean against a real install.

---

## Where definitions live

mm looks for `<pkg>/init.mm` in three locations, in ascending priority:

1. `make/extern/` — the built-in definitions that ship with mm.
2. `$(project.config)/extern/` — definitions local to a project.
3. `$(user.config)/extern/` — a user's personal definitions.

A later location overrides an earlier one, so you can shadow a built-in package
for one project or one machine without touching mm itself. A package also gets an
optional `rules.mm` alongside `init.mm` for any make rules it needs; the per-package
verify report is wired up there.
