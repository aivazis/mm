# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- languages.init}

# the language constructor
#  usage: language.init {language}
define language.init =
# go through all the registered extensions and create a map from the extension to the language
    ${foreach \
        extension, \
        $($(language).extensions), \
        ${eval ext.$(extension) := $(language)} \
    }
endef

# show me
# ${info -- done with languages.init}

# end of file
