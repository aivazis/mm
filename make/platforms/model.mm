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

# fine adjustments
platform.c.defines := MM_PLATFORM_${subst -,_,$(platform)}
platform.c++.defines := MM_PLATFORM_${subst -,_,$(platform)}
platform.cuda.defines := MM_PLATFORM_${subst -,_,$(platform)}
platform.fortran.defines := MM_PLATFORM_${subst -,_,$(platform)}


# show me
# ${info -- done with platforms.model}

# end of file
