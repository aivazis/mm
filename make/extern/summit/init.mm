# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- summit.init}

# add me to the pile
extern += ${if ${findstring summit,$(extern)},,summit}

# # find my configuration file
summit.config := ${dir ${call extern.config,summit}}

# compiler flags
summit.flags ?=
# enable {summit} aware code
summit.defines ?=
# the canonical form of the include directory
summit.incpath ?= $(summit.dir)/include

# linker flags
summit.ldflags ?=
# the canonical form of the lib directory
summit.libpath ?= $(summit.dir)/lib
# the names of the libraries
summit.libraries ?= summit tetra

# my dependencies
summit.dependencies := gmsh gsl slepc petsc metis parmetis summit mpi vtk fortran

# show me
# ${info -- done with summit.init}

# end of file
