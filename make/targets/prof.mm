# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# meta-data
targets.prof.description := compiling with profiling support

# initialize
${eval ${call target.init,prof}}

# adjust
${call target.adjust,prof,$(languages.compiled),flags ldflags}

# build my info target
${eval ${call target.info.flags,prof}}

# end of file
