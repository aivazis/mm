# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

compiler.cython := cython

# prefices for specific categories
cython.prefix.flags :=
cython.prefix.defines := -D
cython.prefix.incpath := -I

cython.prefix.ldflags :=
cython.prefix.libpath := -L
cython.prefix.libraries := -l

# compile time flags
cython.compile.base :=
cython.compile.only := -c
cython.compile.output := -o

# symbols and optimization
cython.debug := -g
cython.opt := -O3
cython.cov := --coverage
cython.prof := -pg
cython.shared :=

# link time flags
cython.link.output := -o
# link a dynamically loadable library
cython.link.dll :=

# end of file
