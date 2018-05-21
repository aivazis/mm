# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# meta-data
targets.debug.description := compiling with support for debugging

# initialize
${eval ${call target.init,debug}}

# adjust
${call target.adjust,debug,c c++ fortran,flags ldflags}

# build my info target
${eval ${call target.info.flags,debug}}

# end of file
