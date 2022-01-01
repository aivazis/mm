# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- mpi.info}

# display the mpi configuration
extern.mpi.info:
	@${call log.sec,"mpi",}
	@${call log.var,"version",$(mpi.version)}
	@${call log.var,"flavor",$(mpi.flavor)}
	@${call log.var,"executive",$(mpi.executive)}
	@${call log.var,"configuration file",$(mpi.config)}
	@${call log.var,"home",$(mpi.dir)}
	@${call log.var,"compiler flags",$(mpi.flags)}
	@${call log.var,"defines",$(mpi.defines)}
	@${call log.var,"incpath",$(mpi.incpath)}
	@${call log.var,"linker flags",$(mpi.ldflags)}
	@${call log.var,"libpath",$(mpi.libpath)}
	@${call log.var,"libraries",$(mpi.libraries)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,mpi}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,mpi}}

# show me
# ${info -- done with mpi.info}

# end of file
