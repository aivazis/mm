# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- developers.info}

# developer info
developer.info:
	${call log.sec,"developer", "developer info"}
	${call log.var,compilers,$(developer.compilers)}
	${call log.sec,"  c options",}
	${call log.var,flags,$(developer.c.flags)}
	${call log.var,defines,$(developer.c.defines)}
	${call log.var,incpath,$(developer.c.incpath)}
	${call log.var,ldflags,$(developer.c.ldflags)}
	${call log.var,libraries,$(developer.c.libraries)}
	${call log.sec,"  c++ options",}
	${call log.var,flags,$(developer.c++.flags)}
	${call log.var,defines,$(developer.c++.defines)}
	${call log.var,incpath,$(developer.c++.incpath)}
	${call log.var,ldflags,$(developer.c++.ldflags)}
	${call log.var,libraries,$(developer.c++.libraries)}
	${call log.sec,"  fortran options",}
	${call log.var,flags,$(developer.fortran.flags)}
	${call log.var,defines,$(developer.fortran.defines)}
	${call log.var,incpath,$(developer.fortran.incpath)}
	${call log.var,ldflags,$(developer.fortran.ldflags)}
	${call log.var,libraries,$(developer.fortran.libraries)}

# show me
# ${info -- done with developers.info}

# end of file
