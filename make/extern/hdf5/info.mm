# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- hdf5.info}

# display the hdf5 configuration
extern.hdf5.info:
	@${call log.sec,"hdf5",}
	@${call log.var,"version",$(hdf5.version)}
	@${call log.var,"configuration file",$(hdf5.config)}
	@${call log.var,"home",$(hdf5.dir)}
	@${call log.var,"compiler flags",$(hdf5.flags)}
	@${call log.var,"defines",$(hdf5.defines)}
	@${call log.var,"incpath",$(hdf5.incpath)}
	@${call log.var,"linker flags",$(hdf5.ldflags)}
	@${call log.var,"libpath",$(hdf5.libpath)}
	@${call log.var,"libraries",$(hdf5.libraries)}
	@${call log.var,"dependencies",$(hdf5.dependencies)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,hdf5}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,hdf5}}

# show me
# ${info -- done with hdf5.info}

# end of file
