# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- compilers.info}

# compiler info
compilers.show:
	${call show.sec,"compilers", "map of languages to compilers"}
	${call show.var,c,$(compiler.c)}
	${call show.var,c++,$(compiler.c++)}
	${call show.var,cuda,$(compiler.cuda)}
	${call show.var,f90,$(compiler.fortran)}
	${call show.var,python,$(compiler.python)}
	${call show.var,cython,$(compiler.cython)}

# show me
# ${info -- done with compilers.info}

# end of file
