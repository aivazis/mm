# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# show me
# ${info -- gtest.info}

# display the gtest configuration
extern.gtest.info:
	${call log.sec,"gtest",}
	${call log.var,"version",$(gtest.version)}
	${call log.var,"configuration file",$(gtest.config)}
	${call log.var,"home",$(gtest.dir)}
	${call log.var,"compiler flags",$(gtest.flags)}
	${call log.var,"defines",$(gtest.defines)}
	${call log.var,"incpath",$(gtest.incpath)}
	${call log.var,"linker flags",$(gtest.ldflags)}
	${call log.var,"libpath",$(gtest.libpath)}
	${call log.var,"libraries",$(gtest.libraries)}
	${call log.var,"dependencies",$(gtest.dependencies)}
	${call log.var,"c++ compile line",${call extern.compile.options,c++,gtest}}
	${call log.var,"c++ link line",${call extern.link.options,c++,gtest}}

# show me
# ${info -- done with gtest.info}

# end of file
