# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- openblas.init}

# add me to the pile
extern += ${if ${findstring openblas,$(extern)},,openblas}

# compiler flags
openblas.flags ?=
# enable {openblas} aware code
openblas.defines := WITH_OPENBLAS
# the canonical form of the include directory
openblas.incpath ?= $(openblas.dir)/include

# linker flags
openblas.ldflags ?=
# the canonical form of the lib directory
openblas.libpath ?= $(openblas.dir)/lib
# the name of the library
openblas.libraries := openblas

# show me
# ${info -- done with openblas.init}

# end of file
