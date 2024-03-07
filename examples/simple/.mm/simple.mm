# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2024 all rights reserved


# simple consists of a python package
simple.packages := simple.pkg
# libraries
simple.libraries := simple.lib
# python extensions
simple.extensions := simple.ext
# a ux bundle
simple.webpack :=
# tests
simple.tests := simple.lib.tests

# load the packages
include $(simple.packages)
# the libraries
include $(simple.libraries)
# the extensions
include $(simple.extensions)
# the ux
include $(simple.webpack)
# the test suites
include $(simple.tests)


# end of file
