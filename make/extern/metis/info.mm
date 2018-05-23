# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the metis configuration
metis.info:
	${call log.sec,"metis",}
	${call log.var,"version",$(metis.version)}
	${call log.var,"configuration file",$(metis.config)}
	${call log.var,"home",$(metis.dir)}
	${call log.var,"compiler flags",$(metis.flags)}
	${call log.var,"defines",$(metis.defines)}
	${call log.var,"incpath",$(metis.incpath)}
	${call log.var,"linker flags",$(metis.ldflags)}
	${call log.var,"libpath",$(metis.libpath)}
	${call log.var,"libraries",$(metis.libraries)}
	${call log.var,"dependencies",$(metis.dependencies)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,metis}}
	${call log.var,"c++ link line",${call package.link.options,c++,metis}}

# end of file
