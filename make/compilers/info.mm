# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- compilers.info}

# compiler info
compilers.info:
	${call log.sec,"compilers", "map of languages to compilers"}
	${call log.var,c,$(compiler.c)}
	${call log.var,c++,$(compiler.c++)}
	${call log.var,cuda,$(compiler.cuda)}
	${call log.var,f90,$(compiler.fortran)}
	${call log.var,python,$(compiler.python)}
	${call log.var,cython,$(compiler.cython)}

# show me
# ${info -- done with compilers.info}

# end of file
