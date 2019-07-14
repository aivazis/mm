# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# show me
# ${info -- petsc.init}

# add me to the pile
extern += ${if ${findstring petsc,$(extern)},,petsc}

# compiler flags
petsc.flags ?=
# enable {petsc} aware code
petsc.defines := WITH_PETSC PETSC_USE_EXTERN_CXX
# the canonical form of the include directory
petsc.incpath ?= $(petsc.dir)/include

# linker flags
petsc.ldflags ?=
# the canonical form of the lib directory
petsc.libpath ?= $(petsc.dir)/lib
# the names of the libraries
petsc.libraries := petsc

# my dependencies
petsc.dependencies =

# show me
# ${info -- done with petsc.init}

# end of file
