# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# add me to the pile
packages += metis

# compiler flags
metis.flags ?=
# enable {metis} aware code
metis.defines := WITH_METIS
# the canonical form of the include directory
metis.incpath ?= $(metis.dir)/include

# linker flags
metis.ldflags ?=
# the canonical form of the lib directory
metis.libpath ?= $(metis.dir)/lib
# the names of the libraries
metis.libraries := metis

# my dependencies
metis.dependencies =

# end of file
