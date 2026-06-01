# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# catch2: a compiled C++ runner; mm compiles all of the suite's sources into a single binary that
# self-registers its TEST_CASEs, then runs it once; the suite supplies {extern := catch2} so the
# Catch2 headers and libraries land on the compile and link command lines
runner.catch2.prepare := compiled
runner.catch2.language := c++


# end of file
