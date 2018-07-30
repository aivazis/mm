# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# the name of the compiler
compiler.c := gcc

# prefices for specific categories
gcc.prefix.flags :=
gcc.prefix.defines := -D
gcc.prefix.incpath := -I

gcc.prefix.ldflags :=
gcc.prefix.libpath := -L
gcc.prefix.libraries := -l

# compile time flags
gcc.compile.only := -c
gcc.compile.output := -o
gcc.compile.makedep := -MMD
gcc.compile.base := -pipe $(gcc.compile.makedep)

# symbols and optimization
gcc.debug := -g
gcc.opt := -O3
gcc.cov := --coverage
gcc.prof := -pg
gcc.shared := -fPIC

# language level
gcc.std.ansi := -ansi
gcc.std.c90 := -std=c90
gcc.std.c99 := -std=c99
gcc.std.c11 := -std=c11

# link time flags
gcc.link.output := -o
# link a dynamically loadable library
gcc.link.dll := -shared

# command line options
gcc.defines = MM_COMPILER_gcc

# dependency generation
# gcc does this in one pass: the dependency file gets generated during the compilation phase so
# there is no extra step necessary to build it
#   usage: gcc.makedep {source} {depfile} {external dependencies}
define gcc.makedep =
    $(cp) $(2) $(2).tmp ; \
    $(sed) \
        -e 's/\#.*//' \
        -e 's/^[^:]*: *//' \
        -e 's/ *\\$$$$//' \
        -e '/^$$$$/d' \
        -e 's/$$$$/ :/' \
        $(2) >> $(2).tmp ; \
    $(mv) $(2).tmp $(2)
endef


# end of file
