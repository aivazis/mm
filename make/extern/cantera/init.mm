# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- cantera.init}

# add me to the pile
extern += ${if ${findstring cantera,$(extern)},,cantera}

# # find my configuration file
cantera.config := ${dir ${call extern.config,cantera}}

# compiler flags
cantera.flags ?=
# enable {cantera} aware code
cantera.defines ?= WITH_CANTERA
# the canonical form of the include directory
cantera.incpath ?= $(cantera.dir)/include

# linker flags
cantera.ldflags ?=
# the canonical form of the lib directory
cantera.libpath ?= $(cantera.dir)/lib
# the names of the libraries
cantera.libraries ?= cantera cantera_fortran

# my dependencies
cantera.dependencies := eigen sundials fortran yaml fmt

# show me
# ${info -- done with cantera.init}

# end of file
