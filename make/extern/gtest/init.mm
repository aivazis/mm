# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- gtest.init}

# add me to the pile
extern += ${if ${findstring gtest,$(extern)},,gtest}

# compiler flags
gtest.flags ?=
# enable {gtest} aware code
gtest.defines := WITH_GTEST
# the canonical form of the include directory
gtest.incpath ?= $(gtest.dir)/include

# linker flags
gtest.ldflags ?=
# the canonical form of the lib directory
gtest.libpath ?= $(gtest.dir)/lib
# the names of the libraries
gtest.libraries += gtest pthread

# my dependencies
gtest.dependencies =

# show me
# ${info -- done with gtest.init}

# end of file
