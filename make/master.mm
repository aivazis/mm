# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# load the logger
include make/log/init.mm

# the list of objects
model := \
    log mm \
    platforms hosts users developers targets builder \
    libraries extensions packages docs tests projects

# the list of methods each object provides
interface := init info model

# import the interface
-include ${foreach object, $(model), \
    ${foreach method, $(interface), make/$(object)/$(method).mm} \
}

# end of file
