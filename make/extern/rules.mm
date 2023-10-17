# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2023 all rights reserved


extern.info:
	@${call log.sec,"extern","support for external packages"}
	@${call log.sec,"  locations",}
	@${call log.var,"built in",$(extern.mm)}
	@${call log.var,"user",$(extern.user)}
	@${call log.var,"project",$(extern.project)}
	@${call log.sec,"  packages",}
	@${call log.var,"supported",$(extern.supported)}
	@${call log.var,"available",$(extern.available)}
	@${call log.var,"requested",$(projects.extern.requested)}
	@${call log.var,"provided",$(projects.extern.loaded)}


# end of file
