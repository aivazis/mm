# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# python
languages.python.sources := py
languages.python.headers :=

# language predicates
languages.python.compiled :=
languages.python.interpreted := yes

# flags
languages.python.categories.compile := flags
languages.python.categories.link :=
# all together
languages.python.categories := \
    $(languages.python.categories.compile) \
    $(languages.python.categories.link)


# end of file
