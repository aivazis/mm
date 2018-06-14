# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- extensions.info}


# extension help
# make the recipe
extensions.info: mm.banner
	$(log) "known extensions: "$(palette.purple)$(extensions)$(palette.normal)
	$(log)
	$(log) "to build one of them, use its name as a target"
	$(log) "    mm ${firstword $(extensions)}"
	$(log)
	$(log) "to get more information about a specific extension, use"
	$(log) "    mm ${firstword $(extensions)}.info"
	$(log)


# bootstrap
# make the extension specific targets
define extensions.workflows =
    # build the recipes for the supporting library
    ${call libraries.workflows,$(1).lib}
    # build recipes
    ${call extension.workflows.build,$(1)}
    # info recipes: show values
    ${call extension.workflows.info,$(1)}
# all done
endef


# build targets
# target factory for building an extension
#   usage: extension.workflows.build {extension}
define extension.workflows.build =

# the main recipe
$(1): $(1).directories $(1).assets
	${call log.asset,"ext",$(1)}

$(1).directories:

$(1).assets: $($(1).pkg) $($(1).lib) $(1).extension

$(1).extension: $($(1).module.so)

$($(1).module.so): $($(1).module.init) $($($(1).lib).staging.archive) \
    ${foreach lib,$($(1).wraps), $($(lib).staging.archive)}
	${call log.action,"dll",${subst $($($(1).project).home)/,,$($(1).module.init)}}
	${call languages.$($(1).module.language).dll,\
            $($(1).module.init), \
            $($(1).module.so), \
            $($(1).lib) $($(1).extern)}

# all done
endef


# make a recipe to log the metadata of a specific extension
# usage: extension.workflows.info {extension}
define extension.workflows.info =
# make the recipe
$(1).info:
	${call log.sec,$(1),"an extension in project '$($(1).project)'"}
	$(log)
	${call log.var,module,$($(1).module)}
	${call log.var,shared object,$($(1).module.so)}
	${call log.var,init entry,$($(1).module.init)}
	${call log.var,support archive,$($(1).lib.archive)}
# all done
endef


# show me
# ${info -- done with extensions.info}

# end of file
