# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- compilers.init}

# the main entry points

# build the compiler command line
#   usage: compiler.compile {language} {compiler} {source} {object} {dependencies}
define compiler.compile =
${strip
    $(2)
        $($(2).compile.only) $(3)
        $($(2).compile.output) $(4)
        $($(2).compile.base)
        $($(2).compile.generate-dependencies)
        ${call compiler.compile.options,$(1),$(2),$(5)}
}
endef


# build the linker command line
#   usage: compiler.compile {language} {compiler} {source} {executable} {dependencies}
define compiler.link =
${strip
    $(2)
        $(3)
        $($(2).link.output) $(4)
        $($(2).compile.base)
        ${call compiler.compile.options,$(1),$(2),$(5)}
        ${call compiler.link.options,$(1),$(2),$(5)}
}
endef


# build a linker command line that creates a shared object
#   usage: compiler.compile {language} {compiler} {source} {dll} {dependencies}
define compiler.dll =
${strip
    $(2)
        $($(2).link.dll)
        $(3)
        $($(2).link.output) $(4)
        $($(2).compile.base)
        ${call compiler.compile.options,$(1),$(2),$(5)}
        ${call compiler.link.options,$(1),$(2),$(5)}
}
endef

# helpers

# assemble the compile time options from the various sources
#   usage: compiler.compile.options {language} {compiler} {dependencies}
define compiler.compile.options =
    $($(2).prefix.incpath)$(mm.home)
    ${call compiler.options,compile,$(1),$(2),$(3)}
endef


# assemble the link time options from the various sources
#   usage: compiler.link.options {language} {compiler} {dependencies}
define compiler.link.options =
    ${call compiler.options,link,$(1),$(2),$(3)}
endef


# assemble the options from the various sources for a given phase
#   usage: compiler.link.options {phase} {language} {compiler} {dependencies}
define compiler.options =
${strip
    ${foreach source, ${call compiler.option.sources,$(2),$(4)},
        ${foreach category, $(languages.$(2).categories.$(1)),
            $($(source).$(category):%=$($(3).prefix.$(category))%)
        }
    }
}
endef


# assemble the list of option sources
#   usage: compiler.option.sources {language} {dependencies}
define compiler.option.sources =
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
