# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- gdal.init}

# add me to the pile
extern += ${if ${findstring gdal,$(extern)},,gdal}

# # find my configuration file
gdal.config := ${dir ${call extern.config,gdal}}

# compiler flags
gdal.flags ?=
# enable {gdal} aware code
gdal.defines := WITH_GDAL
# the canonical form of the include directory
gdal.incpath ?= $(gdal.dir)/include

# linker flags
gdal.ldflags ?=
# the canonical form of the lib directory
gdal.libpath ?= $(gdal.dir)/lib
# the names of the libraries
gdal.libraries := gdal

# my dependencies
gdal.dependencies =

# show me
# ${info -- done with gdal.init}

# end of file
