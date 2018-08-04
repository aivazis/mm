# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- cuda.init}

# add me to the pile
extern += ${if ${findstring cuda,$(extern)},,cuda}

# compiler flags
cuda.flags ?=
# enable {cuda} aware code
cuda.defines += WITH_CUDA
# the canonical form of the include directory
cuda.incpath ?= $(cuda.dir)/include

# linker flags
cuda.ldflags ?=
# the canonical form of the lib directory
cuda.libpath ?= $(cuda.dir)/lib
# the way library names are formed is version dependent; we support 6.x and higher
cuda.libraries ?=

# show me
# ${info -- done with cuda.init}

# end of file
