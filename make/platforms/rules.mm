# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2023 all rights reserved


# platform info
platform.info:
	@${call log.sec,"platform","platform info"}
	@${call log.var,os,$(platform.os)}
	@${call log.var,architecture,$(platform.arch)}
	@${call log.var,tag,$(platform)}
	@${call log.var,macro,$(platform.macro)}


# end of file