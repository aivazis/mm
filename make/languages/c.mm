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
languages.c.categories.compile := flags defines incpath
languages.c.categories.link := ldflags libpath libraries
# all together
languages.c.categories := \
    $(languages.c.categories.compile) \
    $(languages.c.categories.link)


# the compile command line;
#  usage: c.compile {library} {target-object) {source-file}
languages.c.compile = \
    ${call compiler.compile,c,$(compiler.c),$(2),$(3),$($(library).extern.available)}


# end of file
