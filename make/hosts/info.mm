# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- hosts.info}

# host info
host.info:
	@${call log.sec,"host", "host info"}
	@${call log.var,name,$(host.name)}
	@${call log.var,nickname,$(host.nickname)}
	@${call log.var,os,$(host.os)}
	@${call log.var,arch,$(host.arch)}
	@${call log.var,cores,$(host.cores)}

# show me
# ${info -- done with hosts.info}

# end of file
