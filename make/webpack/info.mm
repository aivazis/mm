# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- webpack.info}

# host info
webpack.info: mm.banner
	@$(log) "known ux bundles: "$(palette.targets)$(webpacks)$(palette.normal)
	@$(log)
	@$(log) "to build one of them, use its name as a target"
	@$(log) "    mm ${firstword $(webpacks)}"
	@$(log)
	@$(log) "to get more information about a specific package, use"
	@$(log) "    mm ${firstword $(webpacks)}.info"
	@$(log)


# build the webpack targets
#   usage: webpack.workflows {package}
define webpack.workflows
    # build recipes
    ${call webpack.workflows.build,$(1)}
    # info recipes
    ${call webpack.workflows.info,$(1)}
    # help recipes
    ${call webpack.workflows.help,$(1)}
# all done
endef


# build targets
# usage: webpack.workflows.build {pack}
define webpack.workflows.build

# main target
$(1): $(1).static

$(1).static : $($(1).install.static.assets)

$($(1).install.static.dirs):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

# make the rules that copy the static assets
${foreach asset,$($(1).source.static.assets),
    ${eval ${call webpack.workflows.static.asset,$(1),$(asset)}}
}

# all done
endef


# helpers
define webpack.workflows.static.asset =

    # local variables
    ${eval pack := $(1)}
    ${eval asset := $(2)}
    # the absolute path to the destination of this asset
    ${eval dest := ${subst $($(pack).prefix),$($(pack).install.prefix),$(asset)}}
    # the path to the asset relative to the home of the pack
    ${eval nickname := ${subst $($(pack).prefix),,$(asset)}}

# the rule
$(dest): ${dir $(dest)} $(asset)
	@${call log.action,cp,$(nickname)}
	$(cp) $(asset) $(dest)

# all done
endef


# info targets
# usage: webpack.workflows.info {pack}
define webpack.workflows.info
# make the recipe
$(1).info:
	@${call log.sec,$(1),"a pack in project '$($(1).project)'"}
	@$(log)
	@${foreach category,$($(1).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).$(var))}; \
            } \
        }
	@$(log)
	@$(log) "for an explanation of their purpose, try"
	@$(log)
	@$(log) "    mm $(1).help"
	@$(log)
	@$(log) "related targets:"
	@$(log)

# all done
endef


# help targets
# usage: webpack.workflows.help {pack}
define webpack.workflows.help
# make the recipe
$(1).help:
	@$(log)
	@${call log.sec,$(1),webpack attributes}
	@$(log)
	@${foreach category,$($(1).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).metadoc.$(var))}; \
             } \
        }
	@$(log)
	@$(log) "for a listing of their values, try"
	@$(log)
	@$(log) "    mm $(1).info"
	@$(log)

# all done
endef


# show me
# ${info -- done with webpack.info}

# end of file
