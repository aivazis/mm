# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# cython
languages.cython.extensions := pxd

# language predicates
languages.cython.compiled := yes
languages.cython.interpreted :=

# flags
languages.cython.options.compile := flags defines incpath
languages.cython.options.link := ldflags libpath libraries

# end of file
