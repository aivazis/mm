# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- numpy.init}

# add me to the pile
extern += ${if ${findstring numpy,$(extern)},,numpy}

# compiler flags
numpy.flags ?=
# enable {numpy} aware code
numpy.defines := WITH_NUMPY
# the canonical form of the include directory
numpy.incpath ?= $(numpy.dir)/include

# linker flags
numpy.ldflags ?=
# the canonical form of the lib directory
numpy.libpath ?= $(numpy.dir)/lib
# the names of the libraries
numpy.libraries := npymath

# my dependencies
numpy.dependencies =

# show me
# ${info -- done with numpy.init}

# end of file
