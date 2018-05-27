# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- parmetis.init}

# add me to the pile
extern += ${if ${findstring parmetis,$(extern)},,parmetis}

# compiler flags
parmetis.flags ?=
# enable {parmetis} aware code
parmetis.defines := WITH_PARMETIS
# the canonical form of the include directory
parmetis.incpath ?= $(parmetis.dir)/include

# linker flags
parmetis.ldflags ?=
# the canonical form of the lib directory
parmetis.libpath ?= $(parmetis.dir)/lib
# the names of the libraries
parmetis.libraries := parmetis

# my dependencies
parmetis.dependencies = metis

# show me
# ${info -- done with parmetis.init}

# end of file
