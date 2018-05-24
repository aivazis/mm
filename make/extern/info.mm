# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- extern.info}

extern.info:
	${call log.sec,"extern","support for external packages"}
	${call log.var,"home",$(extern.home)}
	${call log.var,"supported",$(extern.supported)}
	${call log.var,"available",$(extern.available)}

# show me
# ${info -- done with extern.info}

# end of file
