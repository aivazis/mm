# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# cython
languages.cython.sources := .pxd
languages.cython.headers :=

# language predicates
languages.cython.compiled := yes
languages.cython.interpreted :=

# flags
languages.cython.categories.compile := flags defines incpath
languages.cython.categories.link := ldflags libpath libraries


# end of file
