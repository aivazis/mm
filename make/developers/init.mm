# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- developers.init}

# the name of the developer
developer ?= $(user.username)

# developer choices
developer.compilers ?=

# c
developer.c.flags ?=
developer.c.defines ?=
developer.c.incpath ?=
developer.c.ldflags ?=
developer.c.libpath ?=
developer.c.libraries ?=

# c++
developer.c++.flags ?=
developer.c++.defines ?=
developer.c++.incpath ?=
developer.c++.ldflags ?=
developer.c++.libpath ?=
developer.c++.libraries ?=

# fortran
developer.fortran.flags ?=
developer.fortran.defines ?=
developer.fortran.incpath ?=
developer.fortran.ldflags ?=
developer.fortran.libpath ?=
developer.fortran.libraries ?=

# show me
# ${info -- done with developers.init}

# end of file
