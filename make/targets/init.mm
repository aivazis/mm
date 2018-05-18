# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- target.init}

# user info
target := $(host.os)-$(host.arch)

# additional targets
target.variants ?=
# target-specific compiler choices
target.compilers ?=

# contribution to the config path
target.config =

# show me
# ${info -- done with target.init}

# end of file
