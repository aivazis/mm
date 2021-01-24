# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- slepc.info}

# display the slepc configuration
extern.slepc.info:
	@${call log.sec,"slepc",}
	@${call log.var,"version",$(slepc.version)}
	@${call log.var,"configuration file",$(slepc.config)}
	@${call log.var,"home",$(slepc.dir)}
	@${call log.var,"compiler flags",$(slepc.flags)}
	@${call log.var,"defines",$(slepc.defines)}
	@${call log.var,"incpath",$(slepc.incpath)}
	@${call log.var,"linker flags",$(slepc.ldflags)}
	@${call log.var,"libpath",$(slepc.libpath)}
	@${call log.var,"libraries",$(slepc.libraries)}
	@${call log.var,"dependencies",$(slepc.dependencies)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,slepc}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,slepc}}

# show me
# ${info -- done with slepc.info}

# end of file
