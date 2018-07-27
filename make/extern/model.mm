# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# build the data model

# show me
# ${info -- extern.model}

# the list of special packages that don't need actual install locations to be available
fortran.self := true

# initialize the pile of external packages
extern :=

# the path to here
extern.home := $(mm.home)/make/extern

# the set of known packages
extern.supported := \
    ${subst $(extern.home)/,, \
        ${shell find $(extern.home)/* -type d -prune} \
    }

# the set of available packages, i.e. the ones we know where they live
extern.available := \
    ${foreach package, $(extern.supported), \
        ${if ${call extern.exists,$(package)},$(package),} \
    }


# show me
# ${info -- done with extern.model}

# end of file
