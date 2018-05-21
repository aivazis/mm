# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# cuda
languages.cuda.extensions := cu

# language predicates
languages.cuda.compiled := yes
languages.cuda.interpreted :=

# flags
languages.cuda.options.compile := flags defines incpath
languages.cuda.options.link := ldflags libpath libraries

# end of file
