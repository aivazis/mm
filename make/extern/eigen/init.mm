# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- eigen.init}

# add me to the pile
extern += ${if ${findstring eigen,$(extern)},,eigen}

# compiler flags
eigen.flags ?=
# enable {eigen} aware code
eigen.defines := WITH_EIGEN3
# the canonical form of the include directory
eigen.incpath ?= $(eigen.dir)/include/eigen3

# linker flags
eigen.ldflags ?=
# the canonical form of the lib directory
eigen.libpath ?=
# the names of the libraries
eigen.libraries :=

# my dependencies
eigen.dependencies =

# show me
# ${info -- done with eigen.init}

# end of file
