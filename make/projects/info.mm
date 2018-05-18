# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- project.info}

# project help
# usage projects.info.header {project names}
define projects.info.header =
# make the recipe
projects.info: mm.banner
	$(log) "known projects: "$(palette.purple)$(projects)$(palette.normal)
	$(log) "to build one of them, use its name as a target"
	$(log)
	$(log) "    mm ${firstword $(projects)}"
	$(log)
	$(log) "to get more information about a specific project, use"
	$(log)
	$(log) "    mm ${firstword $(projects)}.info"
	$(log)
# all done
endef

# make a recipe to log the metadata of a specific project
# usage: project.recipes.info {project}
define project.recipes.info =
# make the recipe
$(1).info:
	$(log)
	${call log.sec,$(1),project attributes}
	$(log)
	${foreach category,$($(project).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.var,$(1).$(var),$$($(1).$(var))}; \
             } \
        } \
	$(log)
	$(log) "for an explanation of their purpose, try"
	$(log)
	$(log) "    mm $(1).help"
	$(log)
# all done
endef

# make a recipe to show the metadata documentation of a specific project
# usage: project.recipes.info {project}
define project.recipes.help =
# make the recipe
$(1).help:
	$(log)
	${call log.sec,$(1),project attributes}
	$(log)
	${foreach category,$($(project).meta.categories),\
            ${call log.sec,"  "$(category),$($(1).metadoc.$(category))}; \
            ${foreach var,$($(1).meta.$(category)), \
                ${call log.help,$(1).$(var),$($(1).metadoc.$(var))}; \
             } \
        } \
	$(log)
	$(log) "for a listing of their values, try"
	$(log)
	$(log) "    mm $(1).info"
	$(log)
# all done
endef

# make the project specific info and help targets
define project.recipes =
    # make the project info header
    ${call projects.info.header}
    # make individual project targets
    ${foreach project, $(projects),
        # info recipes: show values
        ${call project.recipes.info,$(project)}
        # help recipes: show documentation
        ${call project.recipes.help,$(project)}
    }
# all done
endef

# show me
# ${info -- done with project.info}

# end of file
