# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- pybind11.init}

# add me to the pile
extern += ${if ${findstring pybind11,$(extern)},,pybind11}

# compiler flags
pybind11.flags ?= -flto
# enable {pybind11} aware code
pybind11.defines := WITH_PYBIND11
# the canonical form of the include directory
pybind11.incpath ?= $(pybind11.dir)/include

# linker flags
pybind11.ldflags ?=
# the canonical form of the lib directory
pybind11.libpath ?=
# the names of the libraries
pybind11.libraries :=

# my dependencies
pybind11.dependencies =

# show me
# ${info -- done with pybind11.init}

# end of file
