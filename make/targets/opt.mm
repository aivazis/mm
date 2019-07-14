# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# meta-data
targets.opt.description := optimized build

# initialize
${eval ${call target.init,opt}}

# adjust
${call target.adjust,opt,$(languages.compiled),flags}

# build my info target
${eval ${call target.info.flags,opt}}

# end of file
