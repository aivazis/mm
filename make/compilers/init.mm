# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- compilers.init}

# build the compiler command line
#   usage: compiler.compile {language} {compiler} {object} {source} {dependencies}
define compiler.compile =
${strip
    $(2)
        $($(2).compile.only) $(4)
        $($(2).compile.output) $(3)
        $($(2).compile.base)
        $($(2).compile.generate-dependencies)
        ${call compiler.compile.options,$(1),$(2),$(5)}
}
endef


# assemble the options from the various sources
#   usage: compiler.compile.options {language} {compiler} {dependencies}
define compiler.compile.options =
${strip
    ${foreach source, ${call compiler.compile.option.sources,$(1),$(3)},
        ${foreach category, $(languages.$(1).categories.compile),
            $($(source).$(category):%=$($(2).prefix.$(category))%)
        }
    }
}
endef


# assemble the list of option sources
#   usage: compiler.compile.option.sources {language} {dependencies}
define compiler.compile.option.sources =
${strip
    platform.$(1)
    $(target.variants:%=targets.%.$(1))
    $(developer:%=developers.%.$(1))
    $(2)
}
endef


# show me
# ${info -- done with compilers.init}

# end of file
