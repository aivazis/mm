# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the python configuration
python.info:
	${call log.sec,"python",}
	${call log.var,"version",$(python.version)}
	${call log.var,"configuration file",$(python.config)}
	${call log.var,"home",$(python.dir)}
	${call log.var,"compiler flags",$(python.flags)}
	${call log.var,"defines",$(python.defines)}
	${call log.var,"incpath",$(python.incpath)}
	${call log.var,"linker flags",$(python.ldflags)}
	${call log.var,"libpath",$(python.libpath)}
	${call log.var,"libraries",$(python.libraries)}
	${call log.var,"dependencies",$(python.dependencies)}
	${call log.var,"c++ compile line",${call extern.compile.options,c++,python}}
	${call log.var,"c++ link line",${call extern.link.options,c++,python}}

# end of file
