# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# build the data model

# show me
${info -- platforms.model}

# language specific settings
${foreach \
    language, \
    $(languages), \
    ${eval platform.$(language).flags ?=} \
}

# c
platform.c.flags ?=
platform.c.defines ?=
platform.c.incpath ?=
platform.c.ldflags ?=
platform.c.libpath ?=
platform.c.libraries ?=

# c++
platform.c++.flags ?=
platform.c++.defines ?=
platform.c++.ldflags ?=
platform.c++.incpath ?=
platform.c++.libpath ?=
platform.c++.libraries ?=

# fortran
platform.fortran.flags ?=
platform.fortran.defines ?=
platform.fortran.ldflags ?=
platform.fortran.incpath ?=
platform.fortran.libpath ?=
platform.fortran.libraries ?=


# show me
${info -- done with platforms.model}

# end of file
