# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- vtk.info}

# display the vtk configuration
extern.vtk.info:
	@${call log.sec,"vtk",}
	@${call log.var,"version",$(vtk.version)}
	@${call log.var,"configuration file",$(vtk.config)}
	@${call log.var,"home",$(vtk.dir)}
	@${call log.var,"compiler flags",$(vtk.flags)}
	@${call log.var,"defines",$(vtk.defines)}
	@${call log.var,"incpath",$(vtk.incpath)}
	@${call log.var,"linker flags",$(vtk.flags)}
	@${call log.var,"libpath",$(vtk.libpath)}
	@${call log.var,"requested libraries",$(vtk.required)}
	@${call log.var,"transformed libraries",$(vtk.libraries)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,vtk}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,vtk}}

# show me
# ${info -- done with vtk.info}

# end of file
