# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the pyre configuration
pyre.info:
	${call log.sec,"pyre",}
	${call log.var,"version",$(pyre.version)}
	${call log.var,"configuration file",$(pyre.config)}
	${call log.var,"home",$(pyre.dir)}
	${call log.var,"compiler flags",$(pyre.flags)}
	${call log.var,"defines",$(pyre.defines)}
	${call log.var,"incpath",$(pyre.incpath)}
	${call log.var,"linker flags",$(pyre.ldflags)}
	${call log.var,"libpath",$(pyre.libpath)}
	${call log.var,"libraries",$(pyre.libraries)}
	${call log.var,"dependencies",$(pyre.dependencies)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,pyre}}
	${call log.var,"c++ link line",${call package.link.options,c++,pyre}}

# end of file
