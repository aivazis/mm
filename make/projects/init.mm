# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# show me
# ${info -- project.init}

# meta-data for all projects
project.assetTypes := packages libraries extensions
project.testTypes := tests
project.extraTypes := docs
# put it all together
project.contentTypes := $(project.assetTypes) $(project.testTypes) $(project.extraTypes)

# the project constructor
#   usage: project.init {project}
define project.init =
    # save the name
    $(1).name := $(1)

    # meta-data
    ${eval $(1).major ?= 1}
    ${eval $(1).minor ?= 0}
    ${eval $(1).micro ?= 0}
    ${eval $(1).revision ?= $${strip $${shell $(git.hash)}}}
    ${eval $(1).now.year ?= $${strip $${shell $(date.year)}}}
    ${eval $(1).now.date ?= $${strip $${shell $(date.stamp)}}}

    # directories
    # the top-most directory where we found {.mm}
    ${eval $(1).home ?= $(project.home)}
    # the directory for build products
    ${eval $(1).bldroot ?= $(project.bldroot)}
    # the installation target directory
    ${eval $(1).prefix ?= $(project.prefix)}
    # the staging area for the build intermediate products
    ${eval $(1).tmpdir ?= $(builder.dest.staging)$(1)/}

    # make
    # the directory from where {make} was invoked, i.e. the nearest parent with a local
    # makefile
    ${eval $(1).base ?= $(project.anchor)}
    # the user's {cwd} when they invoked mm
    ${eval $(1).origin ?= $(project.origin)}
    # the local makefile
    ${eval $(1).makefile ?= $(project.makefile)}
    # the project configuration file
    ${eval $(1).config ?= ${wildcard $(project.config)/$(1).mm}}

    # contents
    ${eval $(1).contents ?=}
    # initialize the list of libraries
    ${eval $(1).libraries ?=}
    # the list of python extensions
    ${eval $(1).extensions ?=}
    # the list of python packages
    ${eval $(1).packages ?=}
    # documentation
    ${eval $(1).docs ?=}
    # and the list of tests
    ${eval $(1).tests ?=}

    # dependencies
    # initialize the list of requested project dependencies
    ${eval $(1).extern.requested ?=}
    # the list of external dependencies that we have support for
    ${eval $(1).extern.supported ?=}
    # the list of dependencies in the order they affect the compiler command lines
    ${eval $(1).extern.available ?=}

    # documentation
    # the project metedata categories
    $(1).meta.categories := contents extern directories make

    # build a list of all the project attributes by category
    $(1).meta.directories := home bldroot prefix tmpdir
    $(1).meta.make := base origin makefile config
    $(1).meta.extern := extern.requested extern.supported extern.available
    $(1).meta.contents := $(project.contentTypes)

    # category documentation
    $(1).metadoc.directories := "the layout of the build directories"
    $(1).metadoc.contents := "categories of build products"
    $(1).metadoc.extern := "dependencies to external packages"
    $(1).metadoc.make := "information about the builder"

    # document each one
    $(1).metadoc.name := "the name of the project"
    # directories
    $(1).metadoc.home := "the top level project directory"
    $(1).metadoc.bldroot := "the directory where build products get delivered"
    $(1).metadoc.prefix := "the install target directory"
    $(1).metadoc.tmpdir := "the directory with the intermediate build products"
    # make
    $(1).metadoc.base := "the directory from which mm invoked make"
    $(1).metadoc.origin := "the directory from which you invoked mm"
    $(1).metadoc.makefile := "the local makefile"
    $(1).metadoc.config := "the project configuration file"
    # dependencies
    $(1).metadoc.extern.requested := "requested dependencies"
    $(1).metadoc.extern.supported := "the dependencies for which there is mm support"
    $(1).metadoc.extern.available := "dependencies that were actually found and used"
    # contents
    $(1).metadoc.libraries := "the project libraries"
    $(1).metadoc.extensions := "the python extensions built by this project"
    $(1).metadoc.packages := "the python packages built by this project"
    $(1).metadoc.docs := "documentation for this project"
    $(1).metadoc.tests := "the project test suite"
# all done
endef


# instantiate the project assets
#  usage: project.init.assets {project}
define project.init.assets =
    # go through all types of project assets
    ${foreach type,$(project.contentTypes),
        # and assets of the given {type}
        ${foreach item, $($(1).$(type)),
            # invoke their constructors
            ${call $(type).init,$(1),$(item)}
        }
    }
# all done
endef


# scan through the project contents and collect all the requested dependencies
# usage project.extern.requested {project}
define project.extern.requested =
    ${sort
        ${foreach asset,$($(1).contents),$($(asset).extern.requested)}
    }
# all done
endef


# scan through the project contents and collect all the supported dependencies
# usage project.extern.supported {project}
define project.extern.supported =
    ${sort
        ${foreach asset,$($(1).contents),$($(asset).extern.supported)}
    }
# all done
endef


# scan through the project contents and collect all the available dependencies
# usage project.extern.available {project}
define project.extern.available =
    ${sort
        ${foreach asset,$($(1).contents),$($(asset).extern.available)}
    }
# all done
endef


# show me
# ${info -- done with project.init}

# end of file
