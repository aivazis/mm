<!--
-*- markdown -*-
-*- coding: utf-8 -*-

michael a.g. aïvázis <michael.aivazis@para-sim.com>
(c) 1998-2026 all rights reserved
-->

# mm — workstream to-do

## External facilities (pick up soon)

Let a supported external expose a *family* of conditionally-built libraries
("facilities") so consumers can request a subset and mm trims to what a given
prefix actually provides. Driving case: `pyre` shipping `libpyre-h5`,
`libpyre-mpi`, `libpyre-postgres`, … alongside the `libpyre`/`libjournal` core.

- **Design (agreed, not implemented):**
  [docs/externals-facilities-design.md](docs/externals-facilities-design.md)
- **Shape:** two-party protocol — pyre publishes a facility manifest into its
  prefix at install; `--setup` folds it into the prefix-scoped pkgdb; facilities
  resolve as first-class externals through the existing machinery (no new
  resolver code). Client asks via `<asset>.extern.pyre.facilities`.
- **Next session:** the **producer half** — where in pyre's build the manifest
  is generated and what it enumerates. See "Open decisions" in the design note.

## An example of a driver that names its products

`<driver>.products` (docs/testing.md, "Drivers that produce files") is exercised
by qed's `qed.data` suite but by no example here. Add a generator and a test that
reads its product, e.g. under `examples/simple`, so the feature has a scenario
test of its own.

## Tests of the make functions

mm's make functions have no tests of their own; only the examples exercise them,
and only the parts the examples happen to reach. `extern.is.atLeast` and the
version comparison behind it (`make/extern/init.mm`) are the first candidates: a
scenario that asks for floors below, at and above a package of known version,
for a version with a packaging suffix and epoch (`1:18.6-0ubuntu0.26.04.1`), one
whose components are not all numbers (`18beta1`), and one with no version.

## Package versions from their install location

`extern.is.atLeast` lets a package with no recorded version pass, since only the
conda, dpkg and rpm package databases record one; a package configured by hand,
or found by the adhoc and macports engines, has none. Reading the version from
the install location (a `pkg-config` file, a version header) for every package
would let the floor apply everywhere.

## mpi launcher vocabulary (from pyre)

Move the launcher vocabulary into mm's `extern/mpi` (`mpi.launch`); pyre is only
the consumer. The embedded `share/mm/make/` copy must be mirrored too. Written
up in mm's memory as `project_mm_mpi_launch`; pyre-side context in that repo's
memory under `wip_branch_mpi` / `project_mpi_cpp_layer`.

## Extension child assets and the extern resolve pass (dragon, documented 2026-07-25)

An extension asset delegates its compilation to an internal child library
(`<ext>.lib`, built by the extensions constructor) whose extern state is copied
from the parent's *declared* list at construction time. The global
`projects.extern.resolve` pass iterates `project.contents`, which holds only the
parent: the parent's transitive closure is computed and then consumed by nobody,
while the child — whose state the workflow generator actually bakes into compile
recipes — is never resolved at all. The result: any *induced* dependency (an
edge added by the closure, e.g. `hdf5.parallel -> mpi`) is silently missing from
extension compile lines, while explicitly declared externs survive. The bug was
invisible until a host existed where the parallel hdf5 was the only one on offer
(pyre's `rolling-gcc` docker cell); the symptom was `mpi.h: No such file or
directory` compiling the first hdf5 binding.

- **Patch applied (the minimal fix):** `extensions.workflows` now runs
  `extern.resolve` on the child before generating its recipes, when the package
  database is fully loaded.
- **The remaining work (the structural fix):** the child-asset construction
  copies parent state eagerly (`$(2).lib.extern ?= $($(2).extern)` and the
  derived tiers), which is a whole class of staleness bugs waiting for any
  variable that the model updates after construction. Either derive the child's
  state lazily from the parent's post-resolve values, or enroll child assets in
  `project.contents` so every global pass sees them. Audit the extensions
  constructor for other eagerly-copied parent state with the same hazard.
- **The tests sibling (found 2026-07-26, patched):** `test.staging.target` took a
  hard-`:=` snapshot of the suite's `.extern` for every per-driver target at staging
  time, before the resolve pass enriched the suite's list, so compiled test drivers
  missed induced dependencies too — same symptom (`mpi.h` not found), third asset type.
  Patched by deferring the copy (`=` with an escaped reference), so the driver reads the
  suite's post-resolve list. The audit for other eager parent-state copies should cover
  every asset type that stamps out children: extensions (`.lib`), tests (staged drivers),
  and whatever comes next.
- **Diagnostic trail, for the next dragon:** discovery db was correct
  (`extern.hdf5.info` showed `dependencies = mpi`); the parent's closure was
  correct (probe in `extern.resolve`); the asymmetry showed only in
  `<ext>.info`, which displays the *child's* tiers. Transitive closure is not an
  esoteric feature; the brittleness came from the parent/child split, not the
  resolver.


<!-- end of file -->
