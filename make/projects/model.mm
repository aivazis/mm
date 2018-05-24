# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- project.model}

# hunt for projects among the contents of $(project.config), assuming that each file there is
# the configuration file for some project
projects ?= ${basename ${notdir ${wildcard $(project.config)/*.mm}}}

# load the project files
include ${wildcard $(project.config)/*.mm}


# bootstrap a project
define project.boot =
    # call the project constructor
    ${eval ${call project.init,$(project)}}
    # call the constructors of the various project assets
    ${eval ${call project.init.assets,$(project)}}
    # build the project workflows
    ${eval ${call project.workflows,$(project)}}
    # build the library workflows
    ${foreach library,$($(project).libraries),${eval ${call library.workflows,$(library)}}}

    # assemble the project contents
    ${eval $(project).contents := ${foreach asset,$(project.contentTypes),$($(project).$(asset))}}
    # collect the requested external dependencies
    ${eval $(project).extern.requested := ${call project.extern.requested,$(project)}}
    # collect the supported external dependencies
    ${eval $(project).extern.supported := ${call project.extern.supported,$(project)}}
    # collect the available external dependencies
    ${eval $(project).extern.available := ${call project.extern.available,$(project)}}

# all done
endef


# bootstrap
# ${info --   project constructors}
${foreach project,$(projects), ${eval ${call project.boot, $(project)}}}

# ${info --   loading support for external packages}
${foreach \
    dependency, \
    ${sort ${foreach project,$(projects),$($(project).extern.available)}}, \
    ${eval include $(extern.home)/$(dependency)/init.mm $(extern.home)/$(dependency)/info.mm} \
}

# ${info --   computing the default goal}
.DEFAULT_GOAL := ${if $(projects),projects,help}

# target that builds all known projects
projects: $(projects)

# ${info -- done with model}

# end of file
