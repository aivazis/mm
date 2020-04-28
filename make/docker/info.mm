# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- docker.info}

docker.info: mm.banner
	@${call log.sec,"docker",}
	@${call log.var,"  tool",$(docker.cli)}


# create the docker targets
#   usage: docker.workflows
define docker.workflows


# all done
endef


# show me
# ${info -- done with docker.info}

# end of file
