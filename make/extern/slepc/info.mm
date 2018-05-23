# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the slepc configuration
slepc.info:
	${call log.sec,"slepc",}
	${call log.var,"version",$(slepc.version)}
	${call log.var,"configuration file",$(slepc.config)}
	${call log.var,"home",$(slepc.dir)}
	${call log.var,"compiler flags",$(slepc.flags)}
	${call log.var,"defines",$(slepc.defines)}
	${call log.var,"incpath",$(slepc.incpath)}
	${call log.var,"linker flags",$(slepc.ldflags)}
	${call log.var,"libpath",$(slepc.libpath)}
	${call log.var,"libraries",$(slepc.libraries)}
	${call log.var,"dependencies",$(slepc.dependencies)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,slepc}}
	${call log.var,"c++ link line",${call package.link.options,c++,slepc}}

# end of file
