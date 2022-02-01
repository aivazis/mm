# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
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
$(1): $(1).static $(1).generated
	@${call log.asset,"webpack",$(1)}

# clean up
$(1).clean:
	@${call log.action,"rm",$($(1).staging.prefix)}
	$(rm.force-recurse) $($(1).staging.prefix)

# the webpack bundle
$(1).generated: $($(1).install.generated.assets)

# group all the generated assets together (the '&:' in the rule separator)
$($(1).staging.generated.assets) &: \
    $($(1).staging.babel_config) \
    $($(1).staging.app.sources) | $(1).generate.prep
	$(cd) $($(1).staging.prefix); npm run relay && npm run build

$(1).generate.prep: $(1).config $(1).npm_modules $(1).sources

# build the static assets
$(1).static: $($(1).install.static.assets)

# assemble the staging configuration files
$(1).config: \
    $($(1).staging.page) \
    $($(1).staging.npm_config) $($(1).staging.babel_config) \
	$($(1).staging.webpack_config) $($(1).staging.ts_config)

# stage the sources
$(1).sources: $($(1).staging.app.sources)

# install the dependencies
$(1).npm_modules: $($(1).staging.npm_config)


# the main page where the bundle gets injected
$($(1).staging.page): $($(1).source.page) | $($(1).staging.prefix)
	@${call log.action,"cp", $${subst $($(1).prefix),,$$<}}
	$(cp) $$< $$@

# the npm configuration file lives at top level in the staging area
$($(1).staging.npm_config): $($(1).source.npm_config) | $($(1).staging.prefix)
	@${call log.action,"cp", $${subst $($(1).prefix),,$$<}}
	$(cp) $$< $$@
	@${call log.action,"npm", $${subst $($(1).staging.prefix),,$$@}}
	$(cd) $($(1).staging.prefix); npm i

# so does the babel configuration file
$($(1).staging.babel_config): $($(1).source.babel_config) | $($(1).staging.prefix)
	@${call log.action,"cp", $${subst $($(1).prefix),,$$<}}
	$(cp) $$< $$@

# the webpack configuration file
$($(1).staging.webpack_config): $($(1).source.webpack_config) | $($(1).staging.prefix)
	@${call log.action,"cp", $${subst $($(1).prefix),,$$<}}
	$(cp) $$< $$@

# and the typescript configuration file
$($(1).staging.ts_config): $($(1).source.ts_config) | $($(1).staging.prefix)
	@${call log.action,"cp", $${subst $($(1).prefix),,$$<}}
	$(cp) $$< $$@

# the staging area
$($(1).staging.prefix):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

# static assets
# the directories
$($(1).install.static.dirs):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

# make the rules that copy the static assets
${foreach asset,$($(1).source.static.assets),
    ${eval ${call webpack.workflows.static.asset,$(1),$(asset)}}
}

# make rules that copy the generated assets
${foreach asset,$($(1).staging.generated.assets),
    ${eval ${call webpack.workflows.generated.asset,$(1),$(asset)}}
}

# staging the source code
# the directories
$($(1).staging.app.dirs):
	$(mkdirp) $$@
	@${call log.action,"mkdir",$$@}

# make the rules that copy the sources
${foreach source,$($(1).source.app.sources),
    ${eval ${call webpack.workflows.stage.source,$(1),$(source)}}
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
$(dest): $(asset) | ${dir $(dest)}
	@${call log.action,cp,$(nickname)}
	$(cp) $(asset) $(dest)

# all done
endef


define webpack.workflows.generated.asset =

    # local variables
    ${eval pack := $(1)}
    ${eval asset := $(2)}
    # the absolute path to the destination of this asset
    ${eval dest := ${subst $($(pack).staging.prefix.generated),$($(pack).install.prefix),$(asset)}}
    # the path to the asset relative to the home of the pack
    ${eval nickname := ${subst $($(pack).staging.prefix),,$(asset)}}

# the rule
$(dest): $(asset) | ${dir $(dest)}
	@${call log.action,cp,$(nickname)}
	$(cp) $(asset) $(dest)

# all done
endef


define webpack.workflows.stage.source =

    # local variables
    ${eval pack := $(1)}
    ${eval source := $(2)}
    # the absolute path to the destination of this source
    ${eval dest := ${subst $($(pack).prefix),$($(pack).staging.prefix),$(source)}}
    # the path to the source relative to the home of the pack
    ${eval nickname := ${subst $($(pack).prefix),,$(source)}}

# the rule
$(dest): $(source) | ${dir $(dest)}
	@${call log.action,cp,$(nickname)}
	$(cp) $(source) $(dest)

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

# targets that print the relevant directories
$(1).info.root:
	@echo $($(1).prefix)

$(1).info.config:
	@echo $($(1).prefix)/config

$(1).info.client:
	@echo $($(1).prefix)/client

$(1).info.schema:
	@echo $($(1).prefix)/schema

$(1).info.staging:
	@echo $($(1).staging.prefix)

$(1).info.prefix:
	@echo $($(1).install.prefix)

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
