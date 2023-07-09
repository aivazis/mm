# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- cgal.init}

# add me to the pile
extern += ${if ${findstring cgal,$(extern)},,cgal}

# find my configuration file
cgal.config := ${dir ${call extern.config,cgal}}

# compiler flags
cgal.flags ?=
# enable {cgal} aware code
cgal.defines := WITH_CGAL
# the canonical form of the include directory
cgal.incpath ?= $(cgal.dir)/include

# linker flags
cgal.ldflags ?=
# the canonical form of the lib directory
cgal.libpath ?=
# the name of the library
cgal.libraries :=

# initialize the list of my dependencies
cgal.dependencies =

# show me
# ${info -- done with cgal.init}

# end of file
