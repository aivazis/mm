# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- p2.init}

# add me to the pile
extern += ${if ${findstring p2,$(extern)},,p2}

# # find my configuration file
p2.config := ${dir ${call extern.config,p2}}

# compiler flags
p2.flags ?=
# enable {p2} aware code
p2.defines += WITH_PYRE WITH_JOURNAL
# the canonical form of the include directory
p2.incpath ?= $(p2.dir)/include

# linker flags
p2.ldflags ?=
# the canonical form of the lib directory
p2.libpath ?= $(p2.dir)/lib
# the names of the libraries
p2.libraries ?= # p2

# my dependencies
p2.dependencies =

# show me
# ${info -- done with p2.init}

# end of file
