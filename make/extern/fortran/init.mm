# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- fortran.init}

# add me to the pile
extern += ${if ${findstring fortran,$(extern)},,fortran}

# compiler flags
fortran.flags ?= $($(compiler.fortran).mixed.flags)
# enable {fortran} aware code
fortran.defines ?= $($(compiler.fortran).mixed.defines)
# the canonical form of the include directory
fortran.incpath ?= $($(compiler.fortran).mixed.incpath)

# linker flags
fortran.ldflags ?= $($(compiler.fortran).mixed.ldflags)
# the canonical form of the lib directory
fortran.libpath ?= $($(compiler.fortran).mixed.libpath)
# the names of the libraries
fortran.libraries ?= $($(compiler.fortran).mixed.libraries)

# my dependencies
fortran.dependencies =

# show me
# ${info -- done with fortran.init}

# end of file
