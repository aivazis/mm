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
languages.fortran.categories.compile := flags defines incpath
languages.fortran.categories.link := ldflags libpath libraries
# all together
languages.fortran.categories := \
    $(languages.fortran.categories.compile) \
    $(languages.fortran.categories.link)


# the compile command line;
#  usage: fortran.compile {library} {target-object) {source-file}
languages.fortran.compile = \
    ${call compiler.compile,fortran,$(compiler.fortran),$(2),$(3),$($(1).extern)}


# end of file
