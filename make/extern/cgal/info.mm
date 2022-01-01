# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2022 all rights reserved
#

# show me
# ${info -- cgal.info}

# display the cgal configuration
extern.cgal.info:
	@${call log.sec,"cgal",}
	@${call log.var,"version",$(cgal.version)}
	@${call log.var,"configuration file",$(cgal.config)}
	@${call log.var,"home",$(cgal.dir)}
	@${call log.var,"compiler flags",$(cgal.flags)}
	@${call log.var,"defines",$(cgal.defines)}
	@${call log.var,"incpath",$(cgal.incpath)}
	@${call log.var,"linker flags",$(cgal.ldflags)}
	@${call log.var,"libpath",$(cgal.libpath)}
	@${call log.var,"libraries",$(cgal.libraries)}
	@${call log.var,"dependencies",$(cgal.dependencies)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,cgal}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,cgal}}

# show me
# ${info -- done with cgal.info}

# end of file
