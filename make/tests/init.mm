# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- tests.init}

# the list of testsuites encountered
testsuites ?=

# the testsuite constructor
#   usage: tests.init {project} {testsuite}
define tests.init =
    # add it to the pile
    ${eval testsuites += $(2)}
    # save the name
    ${eval $(2).name := $(2)}
    # attach the project
    ${eval $(2).project := $(1)}
    # the stem for generating testsuite specific names
    ${eval $(2).stem ?= $(1)}

    # the list of external dependencies as requested by the user
    ${eval $(2).extern ?=}
    # initialize the list of requested project dependencies
    ${eval $(2).extern.requested := $($(2).extern)}
    # the list of external dependencies that we have support for
    ${eval $(2).extern.supported ?= ${call extern.is.supported,$($(2).extern.requested)}}
    # the list of dependecies in the order they affect the compiler command lines
    ${eval $(2).extern.available ?= ${call extern.is.available,$($(2).extern.supported)}}

    # a list of additional prerequisites for the top target
    ${eval $(2).prerequisites ?=}

    # artifacts
    # the root of the testsuite relative to the project home
    ${eval $(2).root := tests/$($(2).stem)/}
    # the absolute path to the testsuite directory
    ${eval $(2).prefix := $($($(2).project).home)/$($(2).root)}

    # exclusions
    ${eval $(2).drivers.exclude ?=}

    # the directory structure
    ${eval $(2).directories ?= ${call test.directories,$(2)}}
    ${eval $(2).drivers ?= ${call test.drivers,$(2)}}

    # derived quantities
    ${eval $(2).staging.targets ?= ${call test.staging.targets,$(2)}}

    # documentation
    $(2).meta.categories := general extern artifacts

    # category documentation
    $(2).metadoc.general := "general information"
    $(2).metadoc.extern := "dependencies to external packages"
    $(2).metadoc.artifacts := "information about the test cases"

    # category documentation
    $(2).meta.general := project stem name
    $(2).meta.extern := extern.requested extern.supported extern.available
    $(2).meta.artifacts := root prefix

    # document each one
    # general
    $(2).metadoc.project := "the name of the project to which this testsuite belongs"
    $(2).metadoc.name := "the name of the testsuite"
    $(2).metadoc.stem := "the stem for generating testsuite specific names"
    # dependencies
    $(2).metadoc.extern.requested := "requested dependencies"
    $(2).metadoc.extern.supported := "the dependencies for which there is mm support"
    $(2).metadoc.extern.available := "dependencies that were actually found and used"
    # artifacts
    $(2).metadoc.root := "the path to the testsuite directory relative to the project directory"
    $(2).metadoc.prefix := "the absolute path to the testsuite"

endef

# build the set of testsuite directories
#   usage: test.directories {testsuite}
define test.directories =
    ${strip
        ${addsuffix /,${shell find ${realpath $($(1).prefix)} -type d}}
    }
endef


# build the set of testcase drivers
#   usage: test.drivers {testsuite}
define test.drivers =
    ${strip
        ${filter-out $($(1).drivers.exclude),
            ${foreach directory, $($(1).directories),
                ${wildcard ${addprefix $(directory)*,$(languages.sources)}}
            }
        }
    }
endef


# build the set of make targets for a given testsuite
#   usage: test.targets {testsuite}
define test.staging.targets =
    ${foreach driver,$($(1).drivers),${call test.staging.target,$(1),$(driver)}}
endef


# analyze individual testsuite targets
#   usage: test.staging.target {testsuite} {driver}
define test.staging.target =
    ${strip
        ${eval _trgt := $(1).${subst /,.,${basename $(driver:$($(1).prefix)%=%)}}}
        ${eval $(_trgt).name := $(_trgt)}
        ${eval $(_trgt).source := $(2)}
        ${eval $(_trgt).base := ${basename $($(_trgt).source)}}
        ${eval $(_trgt).suite := $(1)}
        ${eval $(_trgt).language := $(ext${suffix $(2)})}
        ${eval $(_trgt).extern := $($(1).extern)}
        ${eval $(_trgt).compiled := $(languages.$($(_trgt).language).compiled)}
        ${eval $(_trgt).interpreted := $(languages.$($(_trgt).language).interpreted)}
        ${eval $(_trgt).doc ?=}
        ${eval $(_trgt).cases ?=}
        ${eval $(_trgt).clean ?=}
        ${_trgt}
    }
endef


# show me
# ${info -- done with tests.init}

# end of file
