# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# display the fftw configuration
fftw.info:
	${call log.sec,"fftw",}
	${call log.var,"version",$(fftw.version)}
	${call log.var,"configuration file",$(fftw.config)}
	${call log.var,"home",$(fftw.dir)}
	${call log.var,"compiler flags",$(fftw.flags)}
	${call log.var,"defines",$(fftw.defines)}
	${call log.var,"incpath",$(fftw.incpath)}
	${call log.var,"linker flags",$(fftw.ldflags)}
	${call log.var,"libpath",$(fftw.libpath)}
	${call log.var,"libraries",$(fftw.libraries)}
	${call log.var,"dependencies",$(fftw.dependencies)}
	${call log.var,"c++ compile line",${call package.compile.options,c++,fftw}}
	${call log.var,"c++ link line",${call package.link.options,c++,fftw}}

# end of file
