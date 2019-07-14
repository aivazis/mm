# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

compiler.c = clang

# prefices for specific categories
clang.prefix.flags :=
clang.prefix.defines := -D
clang.prefix.incpath := -I

clang.prefix.ldflags :=
clang.prefix.libpath := -L
clang.prefix.libraries := -l

# compile time flags
clang.compile.only := -c
clang.compile.output := -o
clang.compile.makedep := -MMD
clang.compile.base := -pipe $(clang.compile.makedep)

# symbols and optimization
clang.debug := -g
clang.opt := -O3
clang.cov := --coverage
clang.prof := -pg
clang.shared := -fPIC

# language level
clang.std.ansi := -ansi
clang.std.c90 := -std=c90
clang.std.c99 := -std=c99
clang.std.c11 := -std=c11

# link time flags
clang.link.output := -o
# link a dynamically loadable library
clang.link.dll := -shared

# command line options
clang.defines = MM_COMPILER_clang

# dependency generation clang does this in one pass: the dependency file gets generated during
# the compilation phase so there is no extra step necessary to build it
#   usage: clang.makedep {source} {depfile} {external dependencies}
define clang.makedep =
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
