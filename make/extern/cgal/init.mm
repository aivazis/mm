# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- cgal.init}

# add me to the pile
extern += ${if ${findstring cgal,$(extern)},,cgal}

# compiler flags
cgal.flags ?=
# enable {cgal} aware code
cgal.defines := WITH_CGAL
# the canonical form of the include directory
cgal.incpath ?= $(cgal.dir)/include

# linker flags
cgal.ldflags ?=
# the canonical form of the lib directory
cgal.libpath ?= $(cgal.dir)/lib
# the name of the library
cgal.libraries := CGAL

# initialize the list of my dependencies
cgal.dependencies =

# show me
# ${info -- done with cgal.init}

# end of file
