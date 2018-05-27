# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- gmsh.info}

# display the gmsh configuration
extern.gmsh.info:
	${call log.sec,"gmsh",}
	${call log.var,"version",$(gmsh.version)}
	${call log.var,"configuration file",$(gmsh.config)}
	${call log.var,"home",$(gmsh.dir)}
	${call log.var,"compiler flags",$(gmsh.flags)}
	${call log.var,"defines",$(gmsh.defines)}
	${call log.var,"incpath",$(gmsh.incpath)}
	${call log.var,"linker flags",$(gmsh.ldflags)}
	${call log.var,"libpath",$(gmsh.libpath)}
	${call log.var,"libraries",$(gmsh.libraries)}
	${call log.var,"dependencies",$(gmsh.dependencies)}
	${call log.var,"c++ compile line",${call extern.compile.options,c++,gmsh}}
	${call log.var,"c++ link line",${call extern.link.options,c++,gmsh}}

# show me
# ${info -- done with gmsh.info}

# end of file
