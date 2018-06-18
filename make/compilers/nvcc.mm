# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

compiler.cuda := nvcc

# prefices for specific categories
nvcc.prefix.flags :=
nvcc.prefix.defines := -D
nvcc.prefix.incpath := -I

nvcc.prefix.ldflags :=
nvcc.prefix.libpath := -L
nvcc.prefix.libraries := -l

# compile time flags
nvcc.compile.base :=
nvcc.compile.only := -c
nvcc.compile.output := -o
nvcc.compile.generate-dependencies :=

# symbols and optimization
nvcc.debug := -g
nvcc.opt := -O3 -funroll-loops
nvcc.cov := --coverage
nvcc.prof := -pg
nvcc.shared := -Xcompiler -fPIC

# language level
nvcc.std.c++98 := -std=c++98
nvcc.std.c++11 := -std=c++11
nvcc.std.c++14 := -std=c++14
nvcc.std.c++17 := -std=c++17

# link time flags
nvcc.link.output := -o
nvcc.link.shared :=
# link a dynamically loadable library
nvcc.link.dll := -shared

# end of file
