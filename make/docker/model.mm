# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# build the data model

# show me
${info -- docker.model}

# instantiate the docker
${eval ${call docker.init,$(project.prefix)}}

# make the docker targets
${eval ${call docker.workflows}}

# show me
${info -- done with docker.model}

# end of file
