# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- project.info}

# bootstrap
# make all project workflows
#   usage: project.workflows ${project}
define project.workflows =
    # the main project target
    ${call project.main,$(project)}
    # info workflows: show values
    ${call project.workflows.info,$(project)}
    # help workflows: show documentation
    ${call project.workflows.help,$(project)}
# all done
endef


# build targets
# target factory for bulding a project
#   usage: project.main {project}
define project.main =
# the main recipe
$(project): $(project).directories $(project).assets
	${call log.asset,"project",$(project)}

$(project).directories: $($(project).prefix) $($(project).tmpdir)

$(project).assets: ${foreach type,$(project.contentTypes),$($(project).$(type))}

$($(project).tmpdir):
	$(mkdirp) $$@
	${call log.action,"mkdir",$$@}

$(project).clean:
	$(rm.force-recurse) $($(project).tmpdir)
	${call log.action,"rm",$($(project).tmpdir)}
# all done
endef


# targets common to all projects
$(project.prefix) :
	$(mkdirp) $@
	${call log.action,"mkdir",$@}


# informational targets
# project help banner: list the known projects and tell the user what the next steps are
projects.info: mm.banner
	$(log) "known projects: "$(palette.purple)$(projects)$(palette.normal)
	$(log)
	$(log) "to build one of them, use its name as a target"
	$(log) "    mm ${firstword $(projects)}"
	$(log)
	$(log) "to get more information about a specific project, use"
	$(log) "    mm ${firstword $(projects)}.info"
	$(log)


# make a recipe to log the metadata of a specific project
# usage: project.workflows.info {project}
define project.workflows.info =
# make the recipe
$(project).info:
	$(log)
	${call log.sec,$(project),project attributes}
	$(log)
	${foreach category,$($(project).meta.categories),\
            ${call log.sec,"  "$(category),$($(project).metadoc.$(category))}; \
            ${foreach var,$($(project).meta.$(category)), \
                ${call log.var,$(project).$(var),$$($(project).$(var))}; \
             } \
        } \
	$(log)
	$(log) "for an explanation of their purpose, try"
	$(log)
	$(log) "    mm $(project).help"
	$(log)

# make a recipe that displays the project assets
$(project).info.contents:
	${call log.sec,$(project),}
	${call log.var,"contents",$$($(project).contents)}

# all done
endef


# make a recipe to show the metadata documentation of a specific project
# usage: project.workflows.info {project}
define project.workflows.help =
# make the recipe
$(project).help:
	$(log)
	${call log.sec,$(project),project attributes}
	$(log)
	${foreach category,$($(project).meta.categories),\
            ${call log.sec,"  "$(category),$($(project).metadoc.$(category))}; \
            ${foreach var,$($(project).meta.$(category)), \
                ${call log.help,$(project).$(var),$($(project).metadoc.$(var))}; \
             } \
        } \
	$(log)
	$(log) "for a listing of their values, try"
	$(log)
	$(log) "    mm $(1).info"
	$(log)
# all done
endef


# show me
# ${info -- done with project.info}

# end of file
