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
cython.compile.base += -3 --cplus --line-directives
cython.compile.only :=
cython.compile.output := -o

# symbols and optimization; not {cython}'s job really, but the compiler protocol requires them
cython.debug :=
cython.opt :=
cython.cov :=
cython.prof :=
cython.shared :=

# link time flags
cython.link.output := -o
# link a dynamically loadable library
cython.link.dll :=

# end of file
