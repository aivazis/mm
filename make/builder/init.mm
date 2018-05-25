# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- builder.init}

# the builder constructor
#   usage: builder.init {project-bldroot} {target-variants}
define builder.init =
    # the build tag
    ${eval builder.tid := ${if $(2),${subst $(space),$(comma),$(2)}-,}}

    # construct the name of the top level directory
    ${eval builder.root := $(1)/$(builder.tid)$(target)}
    ${eval builder.bindir := $(builder.root)/bin}
    ${eval builder.docdir := $(builder.root)/doc}
    ${eval builder.incdir := $(builder.root)/include}
    ${eval builder.libdir := $(builder.root)/lib}
    ${eval builder.tmpdir := $(builder.root)/tmp}

    # make a pile out for all the relevant directories; this gets used by the rulemaker that makes
    # sure these directories exist, so make sure you add new ones here as well
    ${eval builder.dirs := bindir docdir incdir libdir tmpdir}
    # put them all on a pile
    builder.directories := ${foreach directory,$(builder.dirs),$(builder.$(directory))}

    # extensions for products
    builder.ext.obj := .o
    builder.ext.dep := .d
    builder.ext.lib := .a
    builder.ext.dll := .so

# all done
endef

# show me
# ${info -- done with builder.init}

# end of file
