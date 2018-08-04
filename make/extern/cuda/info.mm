# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- cuda.info}

# display the cuda configuration
extern.cuda.info:
	${call log.sec,"cuda",}
	${call log.var,"version",$(cuda.version)}
	${call log.var,"configuration file",$(cuda.config)}
	${call log.var,"home",$(cuda.dir)}
	${call log.var,"compiler flags",$(cuda.flags)}
	${call log.var,"defines",$(cuda.defines)}
	${call log.var,"incpath",$(cuda.incpath)}
	${call log.var,"linker flags",$(cuda.flags)}
	${call log.var,"libpath",$(cuda.libpath)}
	${call log.var,"requested libraries",$(cuda.required)}
	${call log.var,"transformed libraries",$(cuda.libraries)}
	${call log.var,"cuda compile line",${call extern.compile.options,cuda,cuda}}
	${call log.var,"cuda link line",${call extern.link.options,cuda,cuda}}

# show me
# ${info -- done with cuda.info}

# end of file
