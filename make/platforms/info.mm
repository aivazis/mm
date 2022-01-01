# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- platform.info}

# platform info
platform.info:
	@${call log.sec,"platform","platform info"}
	@${call log.var,os,$(platform.os)}
	@${call log.var,architecture,$(platform.arch)}
	@${call log.var,tag,$(platform)}
	@${call log.var,macro,$(platform.macro)}

# show me
# ${info -- done with platform.info}

# end of file
