# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- packages.init}

# the list of encountered packages
packages ?=

# package constructor
#   usage: packages.init {project} {package}
define packages.init
    # add this to the pile
    ${eval packages += $(2)}
    # save the project
    ${eval $(2).project := $(1)}
    # the stem for generating package specific names
    ${eval $(2).stem ?= $(1)}
    # form the name
    ${eval $(2).name := $($(2).stem)}

    # external dependencies: packages do not typically list these explicitly, for now; their
    # meanings are define in {make/projects/init.mm}
    ${eval $(2).extern ?=}
    ${eval $(2).extern.requested ?=}
    ${eval $(2).extern.supported ?=}
    ${eval $(2).extern.available ?=}

    # build locations
    # the package destination
    ${eval $(2).pycdir = ${builder.dest.pyc}}

    # artifacts
    # the root of the package relative to the project home
    ${eval $(2).root ?= pkg/$($(2).name)}
    # the absolute path to the package source tree
    ${eval $(2).prefix ?= $($($(2).project).home)/$($(2).root)}

    # the directory structure
    ${eval $(2).directories ?= ${call package.directories,$(2)}}
    # the list of sources
    ${eval $(2).sources ?= ${call package.sources,$(2)}}

    # derived artifacts
    # the compile products
    ${eval $(2).staging.pyc = ${call package.pyc,$(2)}}
    # the set of directories that house the compiled products
    ${eval $(2).staging.pycdirs = ${call package.pycdirs,$(2)}}

    # documentation
    $(2).meta.categories := general
    # category documentation
    $(2).metadoc.general := "general information"

    # build a list of all project attributes by category
    $(2).meta.general := project name stem

    # document each one
    # general
    $(2).metadoc.project := "the name of the project to which this package belongs"
    $(2).metadoc.name := "the name of the library"
    $(2).metadoc.stem := "the stem for generating product names"

# all done
endef


# methods

# build the set of source directories
#   usage: package.directories {package}
define package.directories =
    ${strip
        ${shell find $($(1).prefix) -type d}
    }
# all done
endef

# build the set of source files
#   usage: package.sources {package}
define package.sources =
    ${strip
        ${foreach directory, $($(1).directories),
            ${wildcard ${addprefix $(directory)/*,$(languages.python.sources)}}
        }
    }
# all done
endef


# build the set of byte compiled sources
#   usage: package.pyc {package}
define package.pyc =
    ${addprefix $($(1).pycdir)/$($(1).name)/,
        ${addsuffix $(languages.python.pyc),
            ${subst $($(1).prefix)/,,${basename $($(1).sources)}}
        }
    }
# all done
endef


# compute the absolute path to the byte compiled file given its source
#   usage: package.staging.pyc {package} {source}
define package.staging.pyc =
    $($(1).pycdir)/$($(1).name)/${subst $($(1).prefix)/,,${basename $(2)}}$(languages.python.pyc)
# all done
endef


# build the set of directories with the byte compiled files
#   usage: package.staging.pycdirs {package}
define package.pycdirs =
    ${subst $($(1).prefix),$($(1).pycdir)/$($(1).name),$($(1).directories)}
# all done
endef


# show me
# ${info -- done with packages.init}

# end of file
