# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- docker.init}

# the docker constructor
#   usage: docker.init {project-prefix} {project-bldroot}
define docker.init =

    # geometry that defines the path to the tool; leave empty if {docker} is on your {PATH}
    ${eval docker.dir ?= ${empty}}
    ${eval docker.bindir ?= ${empty}}
    # the path to the tool
    ${eval docker.cli ?= ${docker.bindir}docker}

# all done
endef

# show me
# ${info -- done with docker.init}

# end of file
