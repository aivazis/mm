# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# build the data model

# show me
# ${info -- languages.model}

# initialize the list of known languages
languages := c c++ fortran python cython cuda

# load the known languages
include $(languages:%=make/languages/%.mm)

# separate them into categories
define languages.compiled :=
${strip
    ${foreach
        language,
        $(languages),
        ${if $(languages.$(language).compiled),$(language),}
    }
}
endef

define languages.interpreted :=
${strip
    ${foreach
        language,
        $(languages),
        ${if $(languages.$(language).interpreted),$(language),}
    }
}
endef

# invoke the language constructor
# ${info --   language constructor}
${foreach \
    language, \
    $(languages), \
    ${eval ${call language.init,$(language)}} \
}

# build the info recipes
# ${info --   language info recipes}

# language info
${foreach \
    language, \
    $(languages), \
    ${eval compiler.$(language) ?=} \
    ${eval ${call language.recipes.info,$(language)}} \
}

# the suffix map
${eval ${call language.recipes.info.suffix}}

# collect the set of known source extensions
languages.sources := \
    ${sort \
        ${foreach language, $(languages), $(languages.$(language).sources)} \
    }

# collect the set of known header extensions
languages.headers := \
    ${sort \
        ${foreach language, $(languages), $(languages.$(language).headers)} \
    }

# show me
# ${info -- done with languages.model}

# end of file
