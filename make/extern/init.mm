# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
${info -- extern.init}

# initialize the pile of external packages
extern :=


# locate the configuration file of a package
#  usage: extern.config {package-names}
extern.config = \
    ${foreach name,$(1), \
        ${and \
            ${value $(name).dir}, \
            ${realpath $($(name).dir)}, \
            ${realpath $(mm.home)/make/extern/$(name)/init.mm} \
        } \
    }

# existence test
#   usage: extern.exists {package-name}
extern.exists = \
    ${and \
        ${call extern.config,$(1)}, \
        $(1) \
    }


# construct the contribution of an external package to the compile line
#   usage: extern.compile.options {language} {package}
extern.compile.options = \
    ${foreach category, $(languages.$(1).options.compile), \
        ${addprefix $($(compiler.$(1)).prefix.$(category)),$($(2).$(category))} \
    }



# show me
${info -- done with extern.init}

# end of file
