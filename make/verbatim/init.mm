# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- verbatim.init}

# the list of verbatim assets encountere
verbatim ?=


# the verbatim asset constructor
define verbatim.init =
    # add this to the pile
    ${eval verbatim += $(2)}
    # save the project
    ${eval $(2).project := $(1)}

    # set the home
    ${eval $(2).home ?= $($(1).home)/}
    # the path to the assets relative to the project home
    ${eval $(2).root ?=}

    # cruft that must be here to silence undefined variable warning
    # the list of external dependencies as requested by the user
    ${eval $(2).extern ?=}
    # initialize the list of requested project dependencies
    ${eval $(2).extern.requested :=}
    # the list of external dependencies that we have support for
    ${eval $(2).extern.supported :=}
    # the list of dependecies in the order they affect the compiler command lines
    ${eval $(2).extern.available :=}

endef

# show me
# ${info -- done with verbatim.init}

# end of file
