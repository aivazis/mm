# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- webpack.init}

# the list of encountered packages
webpacks ?=

# package constructor
#   usage: webpack.init {project} {pack}
define webpack.init
    # add this to the pile
    ${eval webpacks += $(2)}
    # save the project
    ${eval $(2).project := $(1)}
    # and its home
    ${eval $(2).home ?= $($(1).home)/}
    # the stem for generating package specific names
    ${eval $(2).stem ?= $($(1).stem)}
    # form the name
    ${eval $(2).name ?= $($(2).stem)}

    # the root of the package relative to the project home
    ${eval $(2).root ?= ux/$($(2).name)/}
    # the absolute path to the pack
    ${eval $(2).prefix ?= $($(2).home)$($(2).root)}

    # the name of the configuration directory
    ${eval $(2).config ?= config}
    # the names of directories with static assets
    ${eval $(2).static ?= styles graphics fonts}
    # directories to bundle
    ${eval $(2).bundle ?= react}

    # the list of available directories with static assets
    ${eval $(2).source.static.present := ${call webpack.source.static.present,$(2)}}
    ${eval $(2).source.static.dirs := ${call webpack.source.static.dirs,$(2)}}
    ${eval $(2).source.static.assets := ${call webpack.source.static.assets,$(2)}}

    # build locations

    # install locations
    ${eval $(2).install.prefix ?= $(builder.dest.etc)$($(2).name)/ux/}
    ${eval $(2).install.static.dirs ?= ${call webpack.install.static.dirs,$(2)}}
    ${eval $(2).install.static.assets ?= ${call webpack.install.static.assets,$(2)}}

    # extern specifications seem to be required of all asset types, so here we go...
    ${eval $(2).extern ?=}
    ${eval $(2).extern.requested ?=}
    ${eval $(2).extern.supported ?=}
    ${eval $(2).extern.available ?=}

    # for the help system
    $(2).meta.categories := general layout install
    # cetagory documentation
    $(2).metadoc.general := "general information about the pack"
    $(2).metadoc.layout := "information about the pack layout"
    $(2).metadoc.install := "information about the installed assets"

    # build a list of all pack attributes by category

    # general: the list of attributes
    $(2).meta.general := project stem name
    # document each one
    $(2).metadoc.project := "the name of the project to which this pack belongs"
    $(2).metadoc.name := "the name of the pack"
    $(2).metadoc.stem := "the stem for generating product names"

    # layout: the list of attributes
    $(2).meta.layout := home root prefix config bundle source.static.present
    # document each one
    $(2).metadoc.home := "the project home directory"
    $(2).metadoc.root := "the root of the pack relative to the project home directory"
    $(2).metadoc.config := "the configuration directory"
    $(2).metadoc.bundle := "directories with code to be packed"
    $(2).metadoc.prefix := "the full path to the pack source code"
    $(2).metadoc.source.static.present := "directories with static assets"

    # install: the list of attributes
    $(2).meta.install := install.prefix
    # document each one
    $(2).metadoc.install.prefix := "the root of the asset installation directory"

# all done
endef


# methods
# trim non-existent directories from the list of static source
define webpack.source.static.present =
    ${strip
        ${foreach dir,$($(1).static),
            ${if ${realpath $($(1).prefix)$(dir)},$(dir),}
        }
    }
# all done
endef


# make a pile with all the directories with static assets
define webpack.source.static.dirs =
    ${strip
        ${addsuffix /,
           ${shell find ${realpath ${addprefix $($(1).prefix),$($(1).static)}} -type d}
        }
    }
# all done
endef


# make a pile with all the static assets
define webpack.source.static.assets =
    ${strip
        ${shell find ${addprefix $($(1).prefix),$($(1).source.static.present)} -type f}
    }
# all done
endef


# assemble the list of install directories with static assets
define webpack.install.static.dirs =
    ${subst $($(1).prefix),$($(1).install.prefix),$($(1).source.static.dirs)}
# all done
endef


define webpack.install.static.assets =
    ${subst $($(1).prefix),$($(1).install.prefix),$($(1).source.static.assets)}
# all done
endef



# show me
# ${info -- done with webpack.init}

# end of file
