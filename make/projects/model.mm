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

# invoke the project constuctors
# ${info --   project constructors}
${foreach project,$(projects),${eval ${call project.init,$(project)}}}

# load the project files
include ${wildcard $(project.config)/*.mm}

# invoke the content type constructors on project contents
# ${info --   project content type constructors}
${foreach \
    type, \
    $(project.contentTypes), \
    ${foreach \
        project, \
        $(projects), \
        ${foreach \
            item, \
            $($(project).$(type)), \
            ${eval \
                ${call $(type).init,$(project),$($(project).$(type))} \
            } \
        } \
    } \
}

# instantiate the info recipes
# ${info --   project info recipes}
${eval $(project.recipes)}
# ${info --   library info recipes}
${eval ${call library.recipes,$(libraries)}}

# ${info -- done with model}

# end of file
