# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- pybind11.info}

# display the pybind11 configuration
extern.pybind11.info:
	@${call log.sec,"pybind11",}
	@${call log.var,"version",$(pybind11.version)}
	@${call log.var,"configuration file",$(pybind11.config)}
	@${call log.var,"home",$(pybind11.dir)}
	@${call log.var,"compiler flags",$(pybind11.flags)}
	@${call log.var,"defines",$(pybind11.defines)}
	@${call log.var,"incpath",$(pybind11.incpath)}
	@${call log.var,"dependencies",$(pybind11.dependencies)}
	@${call log.var,"c++ compile line",${call extern.compile.options,c++,pybind11}}
	@${call log.var,"c++ link line",${call extern.link.options,c++,pybind11}}

# show me
# ${info -- done with pybind11.info}

# end of file
