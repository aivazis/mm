# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- users.info}

# user info
user.info:
	@${call log.sec,"user", "user info"}
	@${call log.var,username,$(user.username)}
	@${call log.var,uid,$(user.uid)}
	@${call log.var,home,$(user.home)}
	@${call log.var,name,$(user.name)}
	@${call log.var,email,$(user.email)}

# show me
# ${info -- done with users.info}

# end of file
