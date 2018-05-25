# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# c++
languages.c++.sources := cc cpp cxx c++
languages.c++.headers := h hpp hxx h++ icc

# language predicates
languages.c++.compiled := yes
languages.c++.interpreted :=

# flags
languages.c++.categories.compile := flags defines incpath
languages.c++.categories.link := ldflags libpath libraries
# all together
languages.c++.categories.link := \
    $(languages.c++.categories.compile)
    $(languages.c++.categories.compile)


# end of file
