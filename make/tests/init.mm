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
    # attach the project
    ${eval $(2).project := $(1)}
    # the stem for generating testsuite specific names
    ${eval $(2).stem ?= $(1)}
    # form the name
    ${eval $(2).name := $($(2).stem)}

    # the list of external dependencies as requested by the user
    ${eval $(2).extern ?=}
    # initialize the list of requested project dependencies
    ${eval $(2).extern.requested := $($(2).extern)}
    # the list of external dependencies that we have support for
    ${eval $(2).extern.supported ?= ${call extern.is.supported,$($(2).extern.requested)}}
    # the list of dependecies in the order they affect the compiler command lines
    ${eval $(2).extern.available ?= ${call extern.is.available,$($(2).extern.supported)}}

    # artifacts
    # the root of the testsuite relative to the project home
    ${eval $(2).root := tests/$($(2).stem)/}
    # the absolute path to the testsuite directory
    ${eval $(2).prefix := $($($(2).project).home)/$($(2).root)}

    # a list of additional prerequisites for the top target
    ${eval $(2).prerequisites ?=}

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

# show me
# ${info -- done with tests.init}

# end of file
