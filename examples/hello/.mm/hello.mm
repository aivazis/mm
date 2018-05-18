# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- hello }

# hello builds a library
hello.libraries := hello.lib
# a python extension
hello.extensions := hello.ext
# and a python package
hello.packages = hello.pkg

# the library meta-data
hello.lib.name := hello
hello.lib.root := lib/libhello

# show me
# ${info -- done with hello }

# end of file
