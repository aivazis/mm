# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# user configuration
# look for a generic configuration file
-include config.mm
# developer choices
-include $(user.username).mm
# and a user/host specific configuration file
-include $(user.username)@$(host.nickname).mm

# this list used to include the various project content types; these are now initialized
# dynamically whenever a project that declares assets of that type is encountered; also,
# projects can now declare new asset types and provide support for them in their {mm}
# configuration directory
define model :=
    log mm
    languages platforms hosts users developers
    compilers targets extern
    builder
    projects
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
