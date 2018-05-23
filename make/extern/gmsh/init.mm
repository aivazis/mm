# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# add me to the pile
packages += gmsh

# compiler flags
gmsh.flags ?=
# enable {gmsh} aware code
gmsh.defines := WITH_GMSH
# the canonical form of the include directory
gmsh.incpath ?= $(gmsh.dir)/include

# linker flags
gmsh.ldflags ?=
# the canonical form of the lib directory
gmsh.libpath ?= $(gmsh.dir)/lib
# the names of the libraries
gmsh.libraries := gmsh gl2ps

# my dependencies
gmsh.dependencies =

# end of file
