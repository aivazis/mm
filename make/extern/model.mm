# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# build the data model

# show me
# ${info -- extern.model}

# the list of special packages that don't need actual install locations to be available
fortran.self := true

# initialize the pile of external packages
extern :=

# the locations where package definitions may live
extern.mm := $(mm.home)/make/extern
extern.user := $(user.config)/extern
extern.project := $(project.config)/extern

# assemble them in priority order and filter out the locations that don't exist
extern.all := ${realpath ${extern.mm} ${extern.project} ${extern.user}}

# the set of known packages
extern.supported := \
    ${sort \
        ${foreach location, ${extern.all}, \
            ${subst $(location)/,, \
                ${shell find $(location)/* -type d -prune} \
            } \
        } \
    }

# the set of available packages, i.e. the ones we know where they live
extern.available := \
    ${foreach package, $(extern.supported), \
        ${if ${call extern.exists,$(package)},$(package),} \
    }

# load the configuration files for a set of dependencies
#   usage extern.load {dependencies}
define extern.load =
    ${foreach dep, $(1),
        ${foreach loc, ${extern.all},
            ${eval include ${realpath $(loc)/$(dep)/init.mm $(loc)/$(dep)/info.mm}}
        }
	$(dep)
    }
endef


# show me
# ${info -- done with extern.model}

# end of file
