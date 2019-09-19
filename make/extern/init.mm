# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

# show me
# ${info -- extern.init}

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

foo:
	@echo ${call extern.config,${extern.supported}}


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


# show me
# ${info -- done with extern.init}

# end of file
