# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- platform.init}

# platform id; by default, these match what is known about the host
platform.os := $(host.os)
platform.arch := $(host.arch)
# assemble the platform id
platform := $(platform.os)-$(platform.arch)

# default compilers
platform.compilers ?=

# pull the plaform/architecture specific settings
include make/platforms/$(host.os)/$(host.arch).mm


# show me
# ${info -- done with platform.init}

# end of file
