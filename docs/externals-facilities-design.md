# Design note: facilities of a supported external

**Status:** design agreed, not implemented. Pick up soon.
**Companion:** [externals.md](externals.md) (the four-tier model this extends).

---

## The problem

A supported external is currently a single availability bit: `<pkg>.dir`
resolves (available) or it does not. That is too coarse for an external that
ships a *family* of libraries conditionally.

`pyre` is the driving example. Its build produces:

- `libpyre` + `libjournal` — the unconditional **core**.
- `libpyre-h5`, `libpyre-mpi`, `libpyre-postgres`, `libpyre-host`,
  `libpyre-cuda`, … — **facilities**, each built only when *pyre's own* build
  environment had the underlying external (HDF5, MPI, libpq, CUDA). Each pyre
  sub-project gates on `${findstring hdf5,$(extern.available)}` at pyre build
  time.

Internally pyre links these correctly (its h5 bindings know to pull `libpyre-h5`
and `hdf5`). The gap is on the **consumer** side: a client like `qed` that
declares a dependency on `pyre` has no vocabulary to say *which* pyre facilities
it needs, and mm's `extern/pyre/init.mm` hard-codes a flat
`pyre.libraries ?= pyre journal` that can only ever name the core.

## The framing: an external is a miniature package database

The same three-property model mm applies to the whole external set applies
*recursively, one level down*, inside a single external:

- **supported** — mm knows how to configure the facility.
- **available** — the facility is actually present in *this* pyre prefix
  (decided at pyre's build time, in pyre's environment — **not** rediscoverable
  in the client's environment).
- **requested** — the client explicitly asks for the facility.
- **provided** — `requested ∩ available`; the build accommodates that set or
  fails. (This is an *intersection*, matching `extern.resolve`.)

So "is pyre available" is the wrong question. "Which pyre facilities are
available" is the right one, and it is structurally identical to the top-level
question mm already answers. **pyre plays, for its own facilities, the role a
package manager plays at the top level: it is the authority on what is present,
and it must publish that, because the consumer cannot rediscover it.**

## Client side — how a consumer asks

The consumer declares facilities as a namespaced sub-request under the parent
external. `pyre` (core) is itself a facility in the list:

```makefile
qed.extern.pyre.facilities := pyre-h5 pyre-cuda pyre
```

mm trims this to `qed.extern.pyre.provided` (the ones actually present in the
prefix) and the build accommodates it or fails.

Design decisions on the request:

- **Facility token == installed library stem** (`pyre-h5`, `pyre-cuda`, `pyre`).
  Markers and the `-l` flag then derive mechanically; no translation table.
- **Listing `pyre` (core) explicitly is meaningful, not boilerplate.** It marks
  a *direct* dependence on the core API, distinct from core being *induced* by,
  say, `pyre-h5`. mm already distinguishes direct from induced
  (`extern.unsatisfied.induced` relies on `.extern` still holding the original
  declaration); carry that distinction down to facilities.
- **Scope: asset-level vs project-level (OPEN).** `qed.ext` (the h5 binding) and
  `qed.lib` genuinely use different facilities. Correct home is alongside
  `.extern`, i.e. `qed.ext.extern.pyre.facilities`. Project-level
  (`qed.extern.pyre.facilities`) is an ergonomic shortcut that over-links the
  union into every asset naming pyre (usually harmless: an unused `-l` + rpath).
  Recommendation: asset-level, defaulting to a project-level list.

## Producer side — a two-party protocol, not a probe

Discovery must **not** be a pure file-probe of the prefix. A probe can see
`libpyre-h5.{so,dylib,a}` exists, but it **cannot recover the edges**:
`libpyre-h5` has unresolved HDF5 symbols and needs `-lhdf5` to link. Only pyre's
build knows the edge (`pyre-h5 → hdf5`) and knows what actually compiled. So:

1. **Producer publishes, at install.** pyre emits a facility manifest into its
   own prefix as an install product — once, at install (itself `--setup`/make
   machinery), so it never runs per build. This is the authority: it records
   what compiled *and* the dependency edges.

2. **Consumer ingests, at `--setup`.** mm's `--setup` already interrogates an
   install database and emits a `?=` Makefile fragment into
   `pkg-<pkgdb>.db` (which lives in the **build root**, so it is already
   prefix/variant-scoped — the correct scope for facilities). Facility discovery
   is the same move: find each resolved external's published manifest and fold
   it in.

3. **Pure-probe is the degraded fallback only** — for a pre-manifest pyre built
   before this feature (core + visible libs, edges unknown).

Rejected: computing `.provided` in the make engine on **every build**. It works
(`$(wildcard)` is cheap) but leaves no durable, inspectable artifact of "what
pyre offered," which is exactly what you want when debugging a failed h5 link.

## Why the resolver needs no new code

If the ingested manifest contributes, per facility:

```makefile
pyre-h5.dir          := $(pyre.dir)     # shares the one prefix
pyre-h5.incpath      := $(pyre.incpath)
pyre-h5.libpath      := $(pyre.libpath)
pyre-h5.libraries    := pyre-h5
pyre-h5.dependencies  = pyre hdf5       # the edge only the producer knew
```

…then `pyre-h5` becomes a first-class **configured external** (it has a `.dir`,
so `extern.config` resolves it) exactly like a conda-discovered package. The
existing `extern.closure` / `extern.is.supported` / `extern.is.available` machinery
resolves it with **zero new logic** — `.provided` is just `available` with more
entries, and `.dependencies` induction pulls in core + hdf5 in link order for
free.

The client-side `.facilities` list is therefore **human-facing sugar** that
names the family and scopes the request; mm rewrites it into the flat requested
set and lets stock resolution do the trimming. The miniature package DB collapses
into the real one at resolution time.

**Corollary — keep pyre ONE external.** Do *not* fragment pyre into five
sibling top-level externals hand-maintained in `make/extern/`. There is one
`pyre.dir`, one config, one discovery; facilities are enumerated *inside* it and
share its prefix. Hand-maintained siblings would also drift as sub-projects come
and go — the generated manifest is what keeps supported/available in sync with
what pyre actually built.

## Within vs alongside the pkgdb

- **Authoritative copy lives in the prefix**, producer-owned, edge-preserving.
- **pkgdb holds a snapshot folded in at `--setup`** — matching the pkgdb's
  existing "point-in-time picture of the environment, refresh with `--setup`"
  semantics. Prefer *within* (fold in), because facility discovery is
  **external-specific, not packager-specific**: it must run identically whether
  pyre came from conda, dpkg, or an adhoc source build, so it must **not** live
  inside `_buildCondaPackageDatabase` & friends.
- Include-by-path (`-include $(pyre.dir)/…/pyre.facilities`) is the alternative
  if the packager-specific writers must stay untouched.

## The one hook mm needs

A packager-agnostic way for `--setup` to find a resolved external's manifest.
Cleanest: a **well-known file in the prefix**, e.g.
`$(pyre.dir)/share/mm/extern/pyre.facilities`, that setup folds in when present.
Keeps per-external probing logic out of mm, puts authority on the producer, and
degrades to "no file → core only."

## Guard surface (make + C++)

"Accommodate or fail" needs a concrete hook at both levels, symmetric to how the
producer already gates on `${findstring hdf5,$(extern.available)}`:

- **make:** the consumer conditions its facility-using translation units on
  `${findstring pyre-h5,$(<asset>.extern.pyre.provided)}`.
- **C++:** mm auto-emits a define when a facility is provided (`WITH_PYRE_H5`),
  mirroring the producer-side `WITH_HDF5`, so the source can `#ifdef` the same
  way. Automatic, not hand-written by the consumer.

## Open decisions to settle when picking this up

1. Facility request scope: asset-level vs project-level (lean asset-level).
2. Manifest fold-in vs include-by-path into the pkgdb (lean fold-in).
3. Exact prefix location + format of the published manifest file.
4. Where in pyre's build the manifest is generated and what it enumerates
   (stem, incdir/gateway, `.extern` edges per sub-project) — the **producer
   half**, the natural next design session.
5. Auto-define naming convention (`WITH_PYRE_H5` vs `WITH_PYRE_FACILITY_H5`).

## Concrete next steps

- Producer half: locate the install-time hook in pyre's build that can emit the
  manifest, derived from each `.mm/pyre-*.mm` sub-project (it already knows stem,
  gateway header, and `*.lib.extern`).
- Consumer half: teach `--setup` to discover + fold the manifest; add the
  `.facilities` → requested-set rewrite; emit the `WITH_*` define.
- Update [externals.md](externals.md) with a "facilities" section once the shape
  is real.
