# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# locate the configuration file of a package
#  usage: extern.config {package-names}
extern.config = \
    ${strip \
        ${foreach name,$(1), \
            ${or \
                ${and \
                    ${value $(name).dir}, \
                    ${realpath $($(name).dir)}, \
                    ${realpath ${addsuffix /$(name)/init.mm,$(extern.all)}} \
                }, \
                ${value $(name).self} \
            } \
        } \
    }


# existence test
#   usage: extern.exists {package-name}
extern.exists = \
    ${strip \
        ${if ${call extern.config,$(1)},$(1),} \
    }


# filter the set of external dependencies that are supported
#  usage extern.is.supported {dependencies}
define extern.is.supported =
    ${strip
        ${foreach dependency, $(1),
            ${findstring $(dependency),$(extern.supported)}
        }
    }
endef


# filter the set of external dependencies that are available
#  usage extern.is.available {library}
define extern.is.available =
    ${strip
        ${foreach dependency, $(1),
            ${findstring $(dependency),$(extern.available)}
        }
    }
endef


# conditional
#   usage extern.if.available {package-name} {value-if-available} {value-if-unavailable}
define extern.if.available =
    ${strip
        ${if ${filter $(1),$(extern.available)},$(2)}
    }
endef


# construct the contribution of an external package to the compile line
#   usage: extern.compile.options.this {language} {package}
extern.compile.options.this = \
    ${foreach category, $(languages.$(1).categories.compile), \
        ${addprefix $($(compiler.$(1)).prefix.$(category)),$($(2).$(category))} \
    }


# build the contribution to the compile command line from a set of packages
#  usage: extern.compile.options {language} {packages}
extern.compile.options = \
    ${foreach package, $(2), \
        ${call extern.compile.options.this,$(1),$(package)} \
    }


# construct the contribution of an external package to the link line
#   usage: extern.link.options.this {language} {package}
extern.link.options.this = \
    ${foreach category, $(languages.$(1).categories.link), \
        ${addprefix $($(compiler.$(1)).prefix.$(category)),$($(2).$(category))} \
    }


# build the contribution to the link command line from a set of packages
#  usage: extern.link.options {language} {packages}
extern.link.options = \
    ${foreach package, $(2), \
        ${call extern.link.options.this,$(1),$(package)} \
    }


# the header markers of a package that do not resolve anywhere on its include path; a
# non-empty result is proof the package cannot be compiled against as currently configured
#  usage: extern.markers.headers.missing {package}
extern.markers.headers.missing = \
    ${strip \
        ${foreach marker, $($(1).markers.headers), \
            ${if ${wildcard ${addsuffix /$(marker),$($(1).incpath)}},,$(marker)} \
        } \
    }


# the candidate linker filenames for a library across a package's library path; the linker
# resolves {-lfoo} to {libfoo} with a shared or static suffix, so probe all three
#  usage: extern.markers.lib.candidates {package} {library}
extern.markers.lib.candidates = \
    ${foreach dir, $($(1).libpath), \
        ${addprefix $(dir)/lib$(2),.so .dylib .a} \
    }


# the libraries of a package that resolve to no file on its library path; a non-empty result
# is proof the package cannot be linked against as currently configured
#  usage: extern.markers.libraries.missing {package}
extern.markers.libraries.missing = \
    ${strip \
        ${foreach lib, $($(1).libraries), \
            ${if ${wildcard ${call extern.markers.lib.candidates,$(1),$(lib)}},,$(lib)} \
        } \
    }


# the complete set of unresolved markers for a package; empty when the package checks out
#  usage: extern.markers.problems {package}
extern.markers.problems = \
    ${strip \
        ${call extern.markers.headers.missing,$(1)} \
        ${call extern.markers.libraries.missing,$(1)} \
    }


# the loaded externals whose every marker resolves
extern.markers.ok = \
    ${strip \
        ${foreach package, $(projects.extern.loaded), \
            ${if ${call extern.markers.problems,$(package)},,$(package)} \
        } \
    }


# the loaded externals with at least one unresolved marker
extern.markers.broken = \
    ${strip \
        ${foreach package, $(projects.extern.loaded), \
            ${if ${call extern.markers.problems,$(package)},$(package),} \
        } \
    }


# end of file
