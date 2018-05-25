# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# cuda
languages.cuda.sources := cu
languages.cuda.headers := h

# language predicates
languages.cuda.compiled := yes
languages.cuda.interpreted :=

# flags
languages.cuda.categories.compile := flags defines incpath
languages.cuda.categories.link := ldflags libpath libraries

# all together
languages.cuda.categories.link := \
    $(languages.cuda.categories.compile)
    $(languages.cuda.categories.compile)


# end of file
