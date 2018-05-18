# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- object.info}

# target info
target.info:
	${call log.sec,"target", "target info"}
	${call log.var,variants,$(target.variants)}

# show me
# ${info -- done with object.info}

# end of file
