# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# build the data model

# show me
# ${info -- compilers.model}

# include the compiler specific configuration files
include $(compilers:%=make/compilers/%.mm)

# show me
# ${info -- done with compilers.model}

# end of file
