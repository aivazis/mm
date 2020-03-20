# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2019 all rights reserved
#

compiler.c++ = clang++

# prefices for specific categories
clang++.prefix.flags :=
clang++.prefix.defines := -D
clang++.prefix.incpath := -I

clang++.prefix.ldflags :=
clang++.prefix.libpath := -L
clang++.prefix.libraries := -l

# compile time flags
clang++.compile.only := -c
clang++.compile.output := -o
clang++.compile.makedep := -MMD
clang++.compile.base := -pipe $(clang++.compile.makedep)

# symbols and optimization
clang++.debug := -g
clang++.opt := -O3
clang++.cov := --coverage
clang++.prof := -pg
clang++.shared := -fPIC

# language level
clang++.std.c++98 := -std=c++98
clang++.std.c++11 := -std=c++11
clang++.std.c++14 := -std=c++14
clang++.std.c++17 := -std=c++17

# link time flags
clang++.link.output := -o
clang++.link.shared :=
# link a dynamically loadable library
clang++.link.dll := -shared

# command line options
clang++.defines = MM_COMPILER_clang

# clean up temporaries left behind while compiling
#  usage: clang++.clean {base-name}
clang++.clean = $(1).d

# dependency generation
# clang++ does this in one pass: the dependency file gets generated during the compilation
# phase so there is no extra step necessary to build it
#   usage: clang++.makedep {source} {depfile} {external dependencies}
define clang++.makedep =
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
