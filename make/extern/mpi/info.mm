# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the mpi configuration
mpi.info:
	${call log.sec,"mpi",}
	${call log.var,"version",$(mpi.version)}
	${call log.var,"configuration file",$(mpi.config)}
	${call log.var,"home",$(mpi.dir)}
	${call log.var,"compiler flags",$(mpi.flags)}
	${call log.var,"defines",$(mpi.defines)}
	${call log.var,"incpath",$(mpi.incpath)}
	${call log.var,"linker flags",$(mpi.ldflags)}
	${call log.var,"libpath",$(mpi.libpath)}
	${call log.var,"libraries",$(mpi.libraries)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,mpi}}
	${call log.var,"c++ link line",${call package.link.options,c++,mpi}}

# end of file
