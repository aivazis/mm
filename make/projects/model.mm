# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
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
    ${eval ${call project.init,$(1)}}
    # call the constructors of the various project assets
    ${eval ${call project.init.assets,$(1)}}
    # assemble the project contents
    ${eval $(1).contents := ${foreach asset,$(project.contentTypes),$($(1).$(asset))}}
    # collect the requested external dependencies
    ${eval $(1).extern.requested := ${call project.extern.requested,$(1)}}
    # collect the supported external dependencies
    ${eval $(1).extern.supported := ${call project.extern.supported,$(1)}}
    # collect the available external dependencies
    ${eval $(1).extern.available := ${call project.extern.available,$(1)}}
# all done
endef

define project.boot.workflows =
    # build the project workflows
    ${eval ${call project.workflows,$(1)}}
    # build the asset workflows
    ${foreach category, $(project.contentTypes),
        ${foreach asset, $($(1).$(category)),
            ${eval ${call $(category).workflows,$(asset)}}
        }
    }
# all done
endef


# bootstrap
# ${info --   project constructors}
${foreach project,$(projects), ${eval ${call project.boot,$(project)}}}

# ${info --   loading support for external packages}
#${foreach \
    #dependency, \
    #${sort ${foreach project,$(projects),$($(project).extern.available)}}, \
    #${eval include $(extern.mm)/$(dependency)/init.mm $(extern.mm)/$(dependency)/info.mm} \
#}

projects.extern.requested := ${sort \
    ${foreach project,$(projects),$($(project).extern.available)} \
}

projects.extern.loaded := ${sort \
    ${call extern.load, $(projects.extern.requested)} \
}

# ${info --   project workflows}
${foreach project,$(projects), ${eval ${call project.boot.workflows,$(project)}}}

# ${info --   computing the default goal}
.DEFAULT_GOAL := ${if $(projects),projects,help}

# target that builds all known projects
projects: $(projects)

# clean everything
clean: ${addsuffix .clean,$(projects)}


# ${info -- done with model}

# end of file
