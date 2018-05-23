# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
${info -- extern.info}

extern.info: load vtk.info
	${call log.sec,"extern","information about external packages"}

load:
	${eval include make/extern/vtk/info.mm}

# show me
${info -- done with extern.info}

# end of file
