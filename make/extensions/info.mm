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
    ${if $($(1).lib.sources),${call libraries.workflows,$(1).lib},}
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
$(1): $(1).prerequisites $(1).directories $(1).assets
	${call log.asset,"ext",$(1)}

$(1).prerequisites: $($(1).prerequisites)

$(1).directories: $($(1).tmpdir)

$($(1).tmpdir):
	$(mkdirp) $$@
	${call log.action,"mkdir",$$@}

$(1).assets: ${call extension.workflows.assets,$(1)}

$(1).extension: $($(1).module.so)

$($(1).module.so): ${call extension.workflows.dependencies,$(1)}
	${call log.action,"dll",${subst $($($(1).project).home)/,,$($(1).module.init)}}
	${call languages.$($(1).module.language).dll,\
            $($(1).module.init), \
            $($(1).module.so), \
            $($(1).lib).$($(1).module.language) $($(1).lib) $($(1).extern)}

# typically, extensions have no headers to export; this target is needed when an extension is
# used as a prerequisite
$(1).headers:

# typically, extensions have no archives to build; this target is needed when an extension is
# used as a prerequisite
$(1).archive:

${if ${filter-out $($(1).module.main),$($(1).module.init)},\
    ${call extension.workflows.makeinit,$(1)}, \
}

${if $($(1).capsule), ${call extension.workflows.capsule,$(1)},}

# all done
endef


# build a list of the extension assets
#   usage: extension.workflows.assets {library}
define extension.workflows.assets =
${strip
    $($(1).pkg)
    ${if $($(1).lib.sources),$($(1).lib),}
    ${if $($(1).capsule),$(1).capsule}
    $(1).extension
}
endef


# build a list of the dependencies of the extension module shared object
#   usage: extension.workflows.dependencies {extension}
define extension.workflows.dependencies =
${strip
    $($(1).module.init)
    ${if $($(1).lib.sources),$($($(1).lib).staging.archive),}
    ${foreach lib,$($(1).wraps), $($(lib).staging.archive)}
}
endef


# build a rule to generate the extension {init} from its {main}, if necessary
#   usage: extension.workflows.makeinit {extension}
define extension.workflows.makeinit

    # alias the module
    ${eval module := $($(1).module.main)}
    # and the target
    ${eval module.target := $($(1).module.init)}
    # compute the path of the module relative to the project home
    ${eval module.relpath := ${subst $($($(1).project).home)/,,$(module)}}
    # figure out the module language
    ${eval module.language := $(ext${suffix $($(1).module.main)})}

    # compute the directory structure of the module
    ${eval module.directories := ${addsuffix /,${shell find ${realpath ${dir $(module)}}}}}
    # compute the full set of sources of the module
    ${eval module.sources := \
        ${strip \
            ${foreach directory,$(module.directories), \
                ${wildcard
                    ${addprefix \
                        $(directory)*,\
                        $(languages.$(module.language).sources) \
                            $(languages.$(module.language).headers) \
                    } \
                } \
            } \
        } \
    }

$($(1).module.init) : $($(1).tmpdir) $(module.sources)
	${call log.action,"$(module.language)",$(module.relpath)}
	${call languages.compile,$(module.language),$(module),$(module.target),}

endef


# build rules that publish the extension capsules
#   usage: extension.workflows.capsule {extension}
define extension.workflows.capsule =
    # alias the source
    ${eval capsule.source := $($(1).prefix)$($(1).capsule)}
    # alias the destination
    ${eval capsule.destination := $($($(1).wraps).incdir)$($(1).capsule)}

$(1).capsule : $(capsule.destination)

$(capsule.destination) : $(capsule.source)
	$(cp) $(capsule.source) $(capsule.destination)
	${call log.action,"cp",$(capsule.source)}

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
	${call log.var,main,$($(1).module.main)}
	${call log.var,init,$($(1).module.init)}
	${call log.var,support archive,$($(1).lib.archive)}
# all done
endef


# show me
# ${info -- done with extensions.info}

# end of file
