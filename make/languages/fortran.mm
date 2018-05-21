# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# fortran
languages.fortran.sources := f f77 f90 f95 f03 F F77 F90 F95 F03
languages.fortran.headers := h inc

# language predicates
languages.fortran.compiled := yes
languages.fortran.interpreted :=

# flags
languages.fortran.options.compile := flags defines incpath
languages.fortran.options.link := ldflags libpath libraries

# end of file
