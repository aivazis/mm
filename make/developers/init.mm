# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- developers.init}

# the name of the developer
developer ?= $(user.username)

# developer choices
developer.$(developer).compilers ?=

# costructor
define developer.init =
    ${foreach
        language,
        $(languages),
        ${foreach
            category,
            $(languages.$(language).categories),
            ${eval developers.$(developer).$(language).$(category) ?=}
        }
    }
endef

# show me
# ${info -- done with developers.init}

# end of file
