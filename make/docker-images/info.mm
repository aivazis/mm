# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- docker.info}


# docker image help
# make the recipe
docker-images.info: mm.banner
	@$(log) "known docker images: "$(palette.targets)$(docker-images)$(palette.normal)
	@$(log)
	@$(log) "to build one of them, use its name as a target"
	@$(log) "    mm ${firstword $(docker-images)}"
	@$(log)
	@$(log) "to get more information about a specific image, use"
	@$(log) "    mm ${firstword $(docker-images)}.info"
	@$(log)


# bootstrap
define docker-images.workflows =
    # build recipes
    ${call docker-image.workflows.build,$(1)}
    # info recipes: show values
    ${call docker-image.workflows.info,$(1)}
    # help recipes: show documentation
    ${call docker-image.workflows.help,$(1)}
# all done
endef


# build targets
# target factory for building a docker-image
#   usage: docker-image.workflows.build {docker-image}
define docker-image.workflows.build =

   # build the launch options
   ${eval _launchOptions := ${call docker-image.workflows.launchOptions,$(1)}}

# the main recipe
$(1): $(1).build

# clean up
$(1).clean::

# buld the image
$(1).build:
	$(cd) $($(1).home) ; \
        docker build -f $($(1).dockerfile) -t $($(1).tag) $($(1).build.options) .

# run the image
$(1).run: $(1).build
	$(cd) $($(1).home) ; \
        docker run $($(1).run.options) $($(1).tag)

# launch the image interactively
$(1).launch: $(1).build
	$(cd) $($(1).home) ; \
        docker run -it $(_launchOptions) $($(1).tag) /bin/bash

# all done
endef


# assembly of launch options
define docker-image.workflows.launchOptions =
    ${strip
        $($(1).launch.options)
        ${foreach dir,$($(1).launch.mounts),${call docker-image.workflows.mount,$(1),$(dir)}}
    }
# all done
endef


# mount points
define docker-image.workflows.mount =
    ${eval _img := $(1)}
    ${eval _dir := $(2)}
    ${eval _src := $($(_img).launch.source)$(_dir)}
    ${eval _dst := $($(_img).launch.destination)$(_dir)}
    --mount type=bind,source="$(_src)",destination="$(_dst)"
endef


# make a recipe to log the metadata of a specific docker image
# usage: docker-image.workflows.info {docker-image}
define docker-image.workflows.info =
# make the recipe
$(1).info:
	@${call log.sec,$(1),"a docker image in project '$($(1).project)'"}
	@$(log)
	@${call log.var,tag,$($(1).tag)}
	@${call log.var,home,$($(1).home)}
	@${call log.var,root,$($(1).root)}
	@${call log.var,dockerfile,$($(1).dockerfile)}
	@$(log)
	@$(log) "for an explanation of their purpose, try"
	@$(log)
	@$(log) "    mm $(1).help"
	@$(log)

# all done
endef


# make a recipe to show the metadata documentation of a specific docker image
# usage: docker-image.workflows.help {docker-image}
define docker-image.workflows.help =
# make the recipe
$(1).help:
	@$(log)
	@${call log.sec,$(1),docker image attributes}
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
# ${info -- done with docker.info}

# end of file
