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

${info compiled: $(languages.compiled)}
${info interpreted: $(languages.interpreted)}

# build the info recipes
# ${info --   language info recipes}
${foreach \
    language, \
    $(languages), \
    ${eval ${call language.recipes.info,$(language)}} \
}

# show me
# ${info -- done with languages.model}

# end of file
