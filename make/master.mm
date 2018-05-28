# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# user configuration
# look for a generic configuration file
-include config.mm
# developer choices
-include $(user.username).mm
# and a user/host specific configuration file
-include $(user.username)@$(host.name).mm

# load the logger
include make/log/init.mm

# the list of objects
define model :=
    log mm
    languages platforms hosts users developers
    compilers targets extern
    builder
    packages libraries extensions docs tests projects
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
