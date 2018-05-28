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

# hello builds a library
hello.libraries := hello.lib
# a python extension
hello.extensions := hello.ext
# and a python package
hello.packages := hello.pkg

# the package meta-data
hello.pkg.stem := hello

# the library meta-data
hello.lib.stem := hello
hello.lib.extern := pyre

# the extension meta-data
hello.ext.stem := hello
hello.ext.extern := hello.lib pyre python

# show me
# ${info -- done with hello }

# end of file
