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
# and a python extension
hello.extensions := hello.ext

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

# show me
# ${info -- done with hello }

# end of file
