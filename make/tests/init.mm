# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
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
    # and its home
    ${eval $(2).home ?= $($($(2).project).home)/}
    # the stem for generating testsuite specific names
    ${eval $(2).stem ?= $($(1).stem)}

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
    ${eval $(2).root ?= tests/$($(2).stem)/}
    # the absolute path to the testsuite directory
    ${eval $(2).prefix ?= $($(2).home)$($(2).root)}

    # exclusions
    ${eval $(2).drivers.exclude ?=}

    # the directory structure
    ${eval $(2).directories ?= ${call test.directories,$(2)}}
    ${eval $(2).drivers ?= ${call test.drivers,$(2)}}

    # build the language specific option detabase
    ${eval $(2).languages ?= ${call test.languages,$(2)}}
    # initialize the option database for each source language
    ${call test.languages.options,$(2)}

    # support for affecting how compiling, linking, and launching happen for all test cases
    ${eval $(2).harness ?=}
    ${eval $(2).argv ?=}
    ${eval $(2).flags ?=}
    ${eval $(2).defines ?=}
    ${eval $(2).incpath ?=}
    ${eval $(2).ldflags ?=}
    ${eval $(2).libpath ?=}
    ${eval $(2).libraries ?=}

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


# analyze the set of drivers of a testsuite and deduce the set of source languages
#   usage test.languages {testsuite}
define test.languages =
    ${strip
        ${sort
            ${foreach extension,${sort ${suffix $($(1).drivers)}},$(ext$(extension))}
        }
    }
endef


# build default values for the language specific option database
#   usage test.languages.options {testsuite}
define test.languages.options =
    ${foreach language,$($(1).languages),
        ${foreach category,$(languages.$(language).categories),
            ${eval $(1).$(language).$(category) ?=}
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
        ${eval _trgt := ${subst /,.,$($(1).root)${basename $(2:$($(1).prefix)%=%)}}}
        ${eval $(_trgt).name := $(_trgt)}
        ${eval $(_trgt).source := $(2)}
        ${eval $(_trgt).home := ${dir $(2)}}
        ${eval $(_trgt).base := ${basename $($(_trgt).source)}}
        ${eval $(_trgt).suite := $(1)}
        ${eval $(_trgt).language := $(ext${suffix $(2)})}
        ${eval $(_trgt).extern := $($(1).extern)}
        ${eval $(_trgt).compiled := $(languages.$($(_trgt).language).compiled)}
        ${eval $(_trgt).interpreted := $(languages.$($(_trgt).language).interpreted)}
        ${eval $(_trgt).doc ?=}
        ${eval $(_trgt).cases ?=}
        ${eval $(_trgt).clean ?=}
        ${eval $(_trgt).harness ?= $($(1).harness)}
        ${eval $(_trgt).argv ?= $($(1).argv)}
        ${eval $(_trgt).flags ?= $($(1).flags)}
        ${eval $(_trgt).defines ?= $($(1).defines)}
        ${eval $(_trgt).incpath ?= $($(1).incpath)}
        ${eval $(_trgt).ldflags ?= $($(1).ldflags)}
        ${eval $(_trgt).libpath ?= $($(1).libpath)}
        ${eval $(_trgt).libraries ?= $($(1).libraries)}
        ${foreach category,$(languages.$($(_trgt).language).categories.compile), \
            ${eval $(_trgt).$($(_trgt).language).$(category) ?=} \
        }
        ${foreach category,$(languages.$($(_trgt).language).categories.link), \
            ${eval $(_trgt).$($(_trgt).language).$(category) ?=} \
        }
        ${foreach case,$($(_trgt).cases), \
            ${eval $(case).harness ?= $($(_trgt).harness)} \
            ${eval $(case).argv ?= $($(_trgt).argv)} \
            ${eval $(case).clean ?= $($(_trgt).clean)} \
        }
        ${_trgt}
    }
endef


# show me
# ${info -- done with tests.init}

# end of file
