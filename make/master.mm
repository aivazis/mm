# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# load the logger
include make/log/init.mm

# the list of objects
define model :=
    log mm
    languages platforms hosts users developers
    compilers
    targets
    builder
    libraries extensions packages docs tests projects
endef

# the categories of methods each object provides
categories := init info model

# import the interface
-include \
    ${foreach category, $(categories), \
        ${foreach class, $(model), \
            make/$(class)/$(category).mm \
    } \
}

# end of file
