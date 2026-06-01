# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# add me to the pile
extern += ${if ${findstring catch2,$(extern)},,catch2}

# find my configuration file
catch2.config := ${dir ${call extern.config,catch2}}

# compiler flags
catch2.flags ?=
# enable {catch2} aware code
catch2.defines := WITH_CATCH2
# the canonical form of the include directory
catch2.incpath ?= $(catch2.dir)/include

# linker flags
catch2.ldflags ?=
# the canonical form of the lib directory
catch2.libpath ?= $(catch2.dir)/lib
# its rpath
catch2.rpath = $(catch2.libpath)
# the names of the libraries; {Catch2Main} supplies main() and depends on {Catch2}
catch2.libraries += Catch2Main Catch2

# my dependencies
catch2.dependencies =


# end of file
