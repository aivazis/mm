# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# meta-data
targets.opt.description := optimized build

# initialize
${eval ${call target.init,opt}}

# adjust
${call target.adjust,opt,c c++ fortran,flags}

# build my info target
${eval ${call target.info.flags,opt}}

# end of file
