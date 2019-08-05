# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# build the data model

# show me
# ${info -- platforms.model}

# language specific settings
# initialize the platform specific flags for each language option category
${foreach \
    language, \
    $(languages), \
    ${foreach \
        category, \
        $(languages.$(language).categories), \
        ${eval platform.$(language).$(category) ?=} \
    } \
}

# build the environment variable
platform.macro := MM_PLATFORM_${subst -,_,$(platform)}

# fine adjustments
platform.c.defines := $(platform.macro)
platform.c++.defines := $(platform.macro)
platform.cuda.defines := $(platform.macro)
platform.fortran.defines := $(platform.macro)


# show me
# ${info -- done with platforms.model}

# end of file
