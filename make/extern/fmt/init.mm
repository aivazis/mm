# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- fmt.init}

# add me to the pile
extern += ${if ${findstring fmt,$(extern)},,fmt}

# # find my configuration file
fmt.config := ${dir ${call extern.config,fmt}}

# compiler flags
fmt.flags ?=
# enable {fmt} aware code
fmt.defines ?= WITH_FMT
# the canonical form of the include directory
fmt.incpath ?= $(fmt.dir)/include

# linker flags
fmt.ldflags ?=
# the canonical form of the lib directory
fmt.libpath ?= $(fmt.dir)/lib
# the names of the libraries
fmt.libraries ?= 

# my dependencies
fmt.dependencies :=

# show me
# ${info -- done with fmt.init}

# end of file
