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
	${call log.sec,"  locations",}
	${call log.var,"built in",$(extern.mm)}
	${call log.var,"user",$(extern.user)}
	${call log.var,"project",$(extern.project)}
	${call log.sec,"  packages",}
	${call log.var,"supported",$(extern.supported)}
	${call log.var,"available",$(extern.available)}

# show me
# ${info -- done with extern.info}

# end of file
