# mm — Build Modes

The build *mode* is mm's deployment-intent axis: it answers "what kind of build is
this — an interactive developer build, a local production build, a package for conda
or a distro?" It is **orthogonal to `target`** (the variant axis: `debug`, `opt`,
`shared`, … — compiler/link flags). Mode and target compose freely; conflating them
(e.g. overloading `opt` to mean "release") is the historical mistake this design
avoids. The mode is selected with `--mode=<name>` and defaults to `dev`.

This document records what is implemented today, then surveys the techniques
available for adding *mode-dependent behavior* to the build, with their trade-offs.

---

## Part 1 — What is implemented

Shipped in mm v5.3.0.

### Driver level (`mm`)

- **The `mode` trait.** `mode.validators = isMember("dev", "release", "conda",
  "macports", "ubuntu")`, default `"dev"`. This is the single source of truth for
  the legal mode values exposed to the user.

- **Path dispatch.** Two tables, `_bldrootDispatch` and `_prefixDispatch`, map each
  mode to a method that assembles its build-root / install-prefix. A
  construction-time **firewall** fails the build if either table's keys drift out of
  sync with the validator's choices — a reminder to never add a capability without
  exposing (and implementing) it for the user. ("Defaults to" a baseline is fine;
  "silently fails" because a case was forgotten is not.)

- **Local modes share path logic.** `dev` and `release` are *local* builds: both run
  through `_localBldroot` / `_localPrefix`. `dev` injects no discriminator (its paths
  are byte-for-byte unchanged from before modes existed); `release` injects a
  `release/` segment **above** the suite/tag, so the deployment-intent axis is the
  broadest discriminator and release artifacts can never mix with dev ones.
  `conda` / `macports` / `ubuntu` instead resolve the packager's prefix.

- **`project.mode` reaches make.** `configureProject` yields `project.mode=<mode>`,
  which rides the make command line as a variable override — so `$(project.mode)` is
  live from make startup, before any makefile fragment is read.

### Make level (`make/modes/`)

- **Loading.** `make/merlin.mm` lists `modes` **early** in its `model` (`log mm
  modes …`), so the mode settings exist before any other asset type's `init.mm` or
  `rules.mm` is parsed. `make/modes/init.mm` then:
  ```makefile
  include make/modes/default.mm
  include make/modes/$(project.mode).mm
  ```
  The second is a **hard** `include`: selecting a mode with no file is a fatal make
  error — the make-layer echo of the driver firewall. (An unset *knob* falls through
  to the baseline; a missing *mode* fails loudly.)

- **One file per mode + a `default` baseline.** `default.mm` is the catalog of every
  mode-dependent knob at its baseline value; each `<mode>.mm` overrides only what it
  needs and inherits the rest. The baseline is **non-dev**: `dev` is the single
  special mode (it overrides toward "resolve fresh / least pinned"), and every
  deployment mode inherits the reproducible defaults. So a *new* mode is usually
  near-empty, and forgetting a knob fails safe (toward the reproducible value).

- **Knobs, not mode names.** Settings are named `mode.<consumer>.<knob>` — grouped by
  the consumer that reads them (e.g. `mode.npm.locked`) — and recipes read the knob,
  never branch on `$(project.mode)` directly. This decouples recipes from the mode
  taxonomy.

- **Introspection.** `make/modes/rules.mm` provides `mode.info` (current mode,
  discovered `modes.available`, and the resolved knob values grouped by consumer) and
  `mode.help`. `mode.info` is advertised in the `mm` usage index.

### First consumer — the npm lockfile policy (webpack + vite)

The knob `mode.npm.locked` (baseline `yes`, overridden to empty in `dev`) drives how
the `webpack` and `vite` builders install node dependencies:

- **dev** (`mode.npm.locked` empty) → stage `package.json`, resolve fresh (`npm i`);
  the committed lock is ignored, so dev tracks the ecosystem.
- **deployment modes** (`mode.npm.locked` set) → stage `package.json` **and** the
  committed `package-lock.json`, then install exactly (`npm ci`).

The install rule is keyed on the `node_modules/` directory (not the staged config),
so a missing install always re-runs. Two operator-facing targets round it out:

- `<pack>.lock.seed` — force a clean `npm ci` from the committed lock, *any* mode.
  The get-unstuck button when a fresh `npm i` breaks (e.g. a `latest` dependency
  jumps a major). Guards that a committed lock exists.
- `<pack>.lock.harvest` — copy the freshly-resolved staging lock back to the source
  tree, ready to commit as the new last-known-good.

This consumer only *queries a knob*; it does not change the shape of the build. The
next part is about the cases that do.

---

## Part 2 — Design space for mode-dependent behavior (speculative)

Eventually a mode will need to **extend or override how an asset builder works**, not
just feed it a value: a production webpack/vite build (minify, hashed assets, no
dev-server), release-only template expansion (`meta.py.in` → `meta.py` for a bootstrap
bundle), source-map policy, binary stripping, and so on. This section lays out the
techniques and when each fits. Nothing here is implemented yet.

### The foundation: function-land vs rule-land

Three make constructs are easy to conflate:

- A **rule** (`target: prereqs` + tab recipe) is what make executes, with dependency
  tracking. The real work.
- `${call macro,args}` is **pure text expansion** — it stamps `$(1)`… into a `define`
  and yields a *string*. Parse-time only; no rule, no execution.
- `${eval <text>}` parses a string *as makefile syntax*, which may include rules.

So `${eval ${call <builder>.<op>.<variant>,$(asset)}}` is not "a function instead of a
rule" — it is a **rule factory**: the `define` body *is* rule text, `${call}` stamps
the asset name in, `${eval}` turns the result into a real rule. This is the mm idiom
throughout (`webpack.workflows.*`). The useful split:

- **Function-land** (parse-time, text): *selecting* which template to stamp, computing
  names. Where a `mode.select` resolver would live.
- **Rule-land** (eval'd): the emitted `target: prereq` + recipe that make runs.

### The make facts that govern rule composition

How a target line may repeat decides what is naturally extendable:

| construct                              | repeats?         | semantics                  | good for           |
|----------------------------------------|------------------|----------------------------|--------------------|
| `target: prereqs` (no recipe)          | yes              | prerequisites **accumulate** | **extend** (add steps) |
| `target:: recipe` (double-colon)       | yes              | every recipe **runs**        | **extend** (add actions) |
| `target: prereqs ; recipe` (single-colon) | no (warns/errors) | one recipe only            | **override** → must *select* |

This is the crux: **extend** is additive and native; **override** is not.

### Technique A — EXTEND via native rule accumulation

A builder structures its build as a chain of phony step-targets (vite already does:
`stage → codegen → bundle → install`). A contributor adds a step by *appending a
prerequisite* to an existing node — make merges the two lines:

```makefile
# builder's default chain (already present):
$(asset).bundle: $(asset).codegen
	... build ...

# a mode contributes (a separate rule, emitted only when the mode wants it):
$(asset).bundle: $(asset).minify     # prereqs accumulate; bundle now also needs minify
$(asset).minify: $(asset).codegen
	... minify recipe ...
```

`::` does the same for *recipes* (append an extra action to a step). No templating,
no delegation — just additional rules make composes. Whether the extra rule is
emitted is gated by a knob (`${if $(mode.minify),…}`) or a mode check.

### Technique B — OVERRIDE via emit-time selection

You cannot append to or replace a single-colon recipe (make warns/errors). So
*replacing* a step's behavior must happen when the rule is emitted: pick which
template to stamp. A generic resolver with a default fallback:

```makefile
# usage: mode.select {stem} -> {stem}.$(project.mode) if defined, else {stem}.default
define mode.select
${if $(filter-out undefined,$(flavor $(1).$(project.mode))),$(1).$(project.mode),$(1).default}
endef
```
```makefile
<builder>.<op> := ${call mode.select,<builder>.<op>}
... ${eval ${call $(<builder>.<op>),$(asset)}}
```

The builder always emits *something*; absence of a mode-specific variant falls
through to `.default` — "defaults to, never silently fails," matching the framework.
The npm install is exactly this shape (dev and deploy emit *different* recipes for the
same `node_modules` target; you can't have both).

**Override vs. extend, for free.** A variant that wants to *extend* the default rather
than replace it simply calls the default define and adds to it — a `super()` call:
```makefile
define <builder>.<op>.release
${call <builder>.<op>.default,$(1)}
... extra ...
endef
```

**Safety.** A mode-keyed slot can silently no-op on a typo (`…​.relese` is never
selected; the default quietly runs). To stay true to "don't silently fail," the
resolver (or a load-time check) should firewall any `<builder>.<op>.<x>` whose `<x>`
is not in `modes.available` — the make-layer echo of the driver's dispatch firewall.

### Knob-keyed vs. mode-keyed strategy

A swappable operation can be selected two ways:

- **Knob-keyed** (e.g. `…install.${if $(mode.npm.locked),locked,fresh}`): the recipe
  asks a *semantic* question ("are deps locked?"), not "which mode?". Decoupled and
  shared across modes. **Preferred** when the variation reduces to a reusable knob.
- **Mode-keyed** (`mode.select`): selection on the mode *name*. For genuinely bespoke
  per-mode behavior that does not reduce to a knob.

### Where the logic lives — builder-owned vs. mode-owned (Visitor)

The recurring tension: should mode-specific behavior live with the **builder** (it
defines its own per-mode variants) or with the **mode** (one file gathers all of that
mode's contributions across builders)?

- **Builder-owned** (today): variants defined in the builder. Simple; the builder is
  the expert on its build and decides what is overridable. But "what release does" is
  scattered across builders, and adding behavior means editing each builder.

- **Mode-owned — the Visitor pattern**, which *does* translate to make:
  - Visitor's double dispatch (`element.accept(v)` → `v.visitWebpack(element)`) becomes
    a single call the builder makes at a defined point of its per-asset instantiation:
    `${eval ${call mode.visit,webpack,$(asset)}}`, where `mode.visit` resolves to
    `mode.$(project.mode).webpack` — the mode's "visitWebpack".
  - The **mode is the visitor**: `make/modes/release.mm` defines `mode.release.webpack`,
    `mode.release.vite`, … — all of release's per-builder logic in one place.
  - The **builders are the elements**: each only names its type and exposes the one
    `accept` call; a builder never names a specific mode, so new modes are added
    without editing builders (the point of Visitor).
  - The coupling becomes one-directional and minimal: builders depend only on the
    generic `mode.visit` hook; modes depend on each builder's **extension contract**
    (which step-targets/knobs a visit may touch, and when in the chain the hook fires).
    Defining that contract per builder is the real design work — not the dispatch.

**Recommendation:** start builder-owned while mode-specific behavior is sparse and
builder-intrinsic; graduate to the Visitor/accept-hook once a mode accumulates
*cross-builder* behavior coherent as "what this mode does" (minify + source-maps +
template-expansion + lock, across webpack/vite/…). Centralizing then beats scattering
`${if $(mode.x)}` across every builder.

### The load-order non-issue

It *seems* hard that modes load early but builders define their defaults later. It is
not, because of **set-early / consume-late**: a `<builder>.<op>.<mode>` define is just
a variable; its body is not expanded until the builder `${eval ${call …}}`s it at
asset-instantiation time. So a mode file can legitimately contribute a builder slot
even though it loads before the builder's rules — it is filling a slot the builder
reads later. This is what lets ownership be a *choice* rather than something the load
order dictates.

### A layered mental model

1. **Knobs** — `mode.<consumer>.<knob>` values that tweak an existing recipe. *(have)*
2. **Strategies** — a named operation with a `.default` and optional per-mode/knob
   variants; override by selection, extend by delegating to `.default`.
3. **Hooks/extension points** — phony step-targets and `::` slots a builder exposes so
   contributors can append steps/actions via native rule accumulation.

Reach for the lowest layer that fits: a knob if the variation is a value, native
extension if it is an added step, emit-time selection only when a step's recipe must
be replaced.

### Open questions / candidate first examples

Best resolved against a concrete case:

- **Release template expansion** (`meta.py.in` → `meta.py` for the pyre-boot bundle):
  a clearly mode-specific, *additive* step — exercises Technique A (rule accumulation).
- **Production webpack/vite build** (`--mode production`, minify, hashed assets, no
  dev-server): a *mix* — an override of the build recipe plus extend passes.
- The **extension contract** each builder should expose (its stable step-targets and
  overridable operations) is undefined and should be settled per builder before
  mode-owned overrides are allowed to reach into it.
