# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- eigen.info}

# display the eigen configuration
extern.eigen.info:
	@${call log.sec,"eigen",}
	@${call log.var,"version",$(eigen.version)}
	@${call log.var,"configuration file",$(eigen.config)}
	@${call log.var,"home",$(eigen.dir)}
	@${call log.var,"compiler flags",$(eigen.flags)}
	@${call log.var,"defines",$(eigen.defines)}
	@${call log.var,"incpath",$(eigen.incpath)}
	@${call log.var,"linker flags",$(eigen.ldflags)}
	@${call log.var,"libpath",$(eigen.libpath)}
	@${call log.var,"libraries",$(eigen.libraries)}
	@${call log.var,"dependencies",$(eigen.dependencies)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,eigen}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,eigen}}

# show me
# ${info -- done with eigen.info}

# end of file
