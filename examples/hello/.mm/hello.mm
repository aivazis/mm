# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- hello }

# project meta-data
hello.major := 1
hello.minor := 0

# hello builds a python package
hello.packages := hello.pkg
# a library
hello.libraries := hello.lib
# a python extension
hello.extensions := hello.ext
# and a test suite
hello.tests := hello.tst.hello hello.tst.libhello

# the package meta-data
hello.pkg.stem := hello
hello.pkg.drivers := say

# the library meta-data
hello.lib.stem := hello
hello.lib.extern := pyre

# the extension meta-data
hello.ext.stem := hello
hello.ext.pkg := hello.pkg
hello.ext.wraps := hello.lib
hello.ext.extern := hello.lib pyre python

# the libhello test suite
hello.tst.libhello.stem := libhello
hello.tst.libhello.extern := hello.lib pyre

# the hello package test suite
hello.tst.hello.stem := hello
hello.tst.hello.extern :=

# show me
# ${info -- done with hello }

# end of file
