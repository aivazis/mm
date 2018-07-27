# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- fortran.init}

# add me to the pile
extern += ${if ${findstring fortran,$(extern)},,fortran}

# compiler flags
fortran.flags ?= $($(compiler.fortran).flags)
# enable {fortran} aware code
fortran.defines ?= $($(compiler.fortran).defines)
# the canonical form of the include directory
fortran.incpath ?= $($(compiler.fortran).incpath)

# linker flags
fortran.ldflags ?= $($(compiler.fortran).ldflags)
# the canonical form of the lib directory
fortran.libpath ?= $($(compiler.fortran).libpath)
# the names of the libraries
fortran.libraries ?= $($(compiler.fortran).libraries)

# my dependencies
fortran.dependencies =

# show me
# ${info -- done with fortran.init}

# end of file
