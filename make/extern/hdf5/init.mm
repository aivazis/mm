# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# show me
# ${info -- hdf5.init}

# add me to the pile
extern += ${if ${findstring hdf5,$(extern)},,hdf5}

# compiler flags
hdf5.flags ?=
# enable {hdf5} aware code
hdf5.defines := WITH_HDF5
# the canonical form of the include directory
hdf5.incpath ?= $(hdf5.dir)/include

# linker flags
hdf5.ldflags ?=
# the canonical form of the lib directory
hdf5.libpath ?= $(hdf5.dir)/lib
# the names of the libraries
hdf5.libraries := hdf5_cpp hdf5

# my dependencies
hdf5.dependencies =

# show me
# ${info -- done with hdf5.init}

# end of file
