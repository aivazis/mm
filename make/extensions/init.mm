# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- extensions.init}

# the list of all extensions encountered
extensions ?=

# the extension constructor
#   usage: extensions.init {project} {extension}
define extensions.init =
    # add it to the pile
    ${eval extensions += $(2)}
    # save the project
    ${eval $(2).project := $(1)}

    # the stem for generating extension specific names; it gets used to build the extension
    # archive name, the include directory with the public headers, and the name of the module
    ${eval $(2).stem ?= $(1)}

    # the list of external dependencies
    ${eval $(2).extern ?=}
    # initialize the list of requested project dependencies
    ${eval $(2).extern.requested := $($(2).extern)}
    # the list of external dependencies that we have support for
    ${eval $(2).extern.supported ?= ${call extern.is.supported,$($(2).extern.requested)}}
    # the list of dependecies in the order they affect the compiler command lines
    ${eval $(2).extern.available ?= ${call extern.is.available,$($(2).extern.supported)}}

    # layout
    # the root of the extension source tree relative to the project home
    ${eval $(2).root ?= ext/ext$($(2).stem)}
    # the absolute path to the extension source tree
    ${eval $(2).prefix ?= $($($(2).project).home)/$($(2).root)}

    # the name of the module
    ${eval $(2).module ?= $($(2).stem)}
    # the source file with the python initialization routine
    ${eval $(2).module.init ?= ${call extension.module.init,$(2)}}
    # the name of the shared object
    ${eval $(2).module.so ?= $($(2).module)$(python.suffix.module)}

    # the name of the support archive
    ${eval $(2).lib ?= $(2).lib}
    # its stem
    ${eval $(2).lib.stem ?= $($(2).stem)module}
    # its location
    ${eval $(2).lib.root ?= ext/ext$($(2).stem)}
    # its external dependencies
    ${eval $(2).lib.extern ?= $($(2).extern)}
    # in general, extensions have no public headers
    ${eval $(2).lib.headers ?=}
    # construct it
    ${call libraries.init,$(1),$(2).lib}
    # adjust its sources
    ${eval $(2).lib.sources ?= ${call extension.sources,$(2),$(2).lib}}

endef


# helpers

# identify the extension init file
#   usage: extension.module.init {extension}
define extension.module.init
    ${strip
        ${foreach suffix,$(languages.sources),
            ${wildcard $($(1).prefix)/$($(1).module).$(suffix)}
        }
    }
endef


# collect the set of sources that comprise the extension supporting library
#   usage: extension.sources {extension} {library}
define extension.sources
    ${strip
        ${filter-out $($(1).module.init),$($(2).sources)}
    }
endef

# show  ${info -- done with extensions.init}

# end of file
