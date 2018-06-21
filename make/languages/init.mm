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
    # go through all the registered suffixes and create a map from the suffix to the language
    ${foreach
        extension,
        $(languages.$(1).sources),
        ${eval ext$(extension) := $(1)}
    }
    # assemble the option categories in one pile
    ${eval languages.$(1).categories := \
        $(languages.$(1).categories.compile) $(languages.$(1).categories.link) \
    }
# all done
endef

# show me
# ${info -- done with languages.init}

# end of file
