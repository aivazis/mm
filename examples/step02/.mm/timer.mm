# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# the project assets
timer.packages := timer.pkg
timer.libraries := timer.lib
timer.tests := timer.lib.tests timer.pkg.tests

# load configurations
include $(timer.packages)
include $(timer.libraries)
include $(timer.tests)


# end of file
