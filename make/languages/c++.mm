# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# c++
languages.c++.sources := C cc cpp cxx c++
languages.c++.headers := H h hpp hxx h++ icc

# language predicates
languages.c++.compiled := yes
languages.c++.interpreted :=

# flags
languages.c++.options.compile := flags defines incpath
languages.c++.options.link := ldflags libpath libraries

# end of file
