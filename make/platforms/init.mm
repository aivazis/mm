# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- platform.init}

# platform id; by default, these match what is known about the host
platform.os := $(host.os)
platform.arch := $(host.arch)
# assemble the platform id
platform := $(platform.os)-$(platform.arch)

# default compilers
platform.compilers ?=

# language specific settings
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
# ${info -- done with platform.init}

# end of file
