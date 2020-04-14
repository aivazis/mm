# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# build the data model

# show me
# ${info -- compilers.model}

# assemble the list of compilers
#    order: defaults from the platform, then user configuration files, then mm command line
compilers := \
    $(platform.compilers) $(target.compilers) \
    $(developer.$(developer).compilers) \
    $(mm.compilers)

# include the compiler specific configuration files
include $(compilers:%=make/compilers/%.mm)

# language specific settings
# initialize the compiler specific flags for each language option category
${foreach \
    language, \
    $(languages), \
    ${if ${value compiler.$(language)}, \
        ${foreach \
            category, \
            $(languages.$(language).categories), \
            ${eval $(compiler.$(language)).$(category) ?=} \
        } \
    } \
}


# show me
# ${info -- done with compilers.model}

# end of file
