# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# c
languages.c.sources := c
languages.c.headers := h

# language predicates
languages.c.compiled := yes
languages.c.interpreted :=

# flags
languages.c.options.compile := flags defines incpath
languages.c.options.link := ldflags libpath libraries

# end of file
