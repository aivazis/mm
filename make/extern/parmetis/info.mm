# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the parmetis configuration
parmetis.info:
	${call log.sec,"parmetis",}
	${call log.var,"version",$(parmetis.version)}
	${call log.var,"configuration file",$(parmetis.config)}
	${call log.var,"home",$(parmetis.dir)}
	${call log.var,"compiler flags",$(parmetis.flags)}
	${call log.var,"defines",$(parmetis.defines)}
	${call log.var,"incpath",$(parmetis.incpath)}
	${call log.var,"linker flags",$(parmetis.ldflags)}
	${call log.var,"libpath",$(parmetis.libpath)}
	${call log.var,"libraries",$(parmetis.libraries)}
	${call log.var,"dependencies",$(parmetis.dependencies)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,parmetis}}
	${call log.var,"c++ link line",${call package.link.options,c++,parmetis}}

# end of file
