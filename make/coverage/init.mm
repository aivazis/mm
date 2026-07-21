# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# whether a coverage build is in effect; set in the model pass once {target.variants} is final
coverage.active ?=
# the instrumentation back end: {llvm} for the clang family, {gcov} for gcc; resolved from the
# c++ compiler in the model pass
coverage.backend ?=
# the directory that collects the raw per-run profile data and the rendered reports; anchored under
# the staging area in the model pass, since these are derived products of a build, not shipped files
coverage.raw ?=
coverage.report ?=
# the lcov interchange file the vscode {Coverage Gutters} extension and the html renderers consume
coverage.info ?=
# the merged, indexed profile the llvm reporters read; the single product of folding all the raw
# per-run profiles together
coverage.profdata ?=
# extra instrumented binaries a project wants folded into the llvm report beyond the shared
# libraries mm discovers automatically; a header-only template library should add its compiled test
# drivers here, since the templates are instantiated into the drivers rather than into any {.so}
coverage.objects ?=


# end of file
