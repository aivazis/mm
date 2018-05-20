# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- compilers.init}

# assemble the list of compilers
#    order: defaults from the platform, then user configuration files, then mm command line
compilers := \
    $(platform.compilers) $(target.compilers) \
    $($(developer).compilers) \
    $(mm.compilers)

# include the compiler specific configuration files
include $(compilers:%=make/compilers/%.mm)

# show me
# ${info -- done with compilers.init}

# end of file
