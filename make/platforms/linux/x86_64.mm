# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# platform id; by default, these match what is known about the host
platform.os = $(host.os)
platform.arch = $(host.arch)

# default compilers; specify as many as necessary in the form {family} or {family/language}
platform.compilers = gcc nvcc python cython

# clean up the debug symbols compilers leave behind
#     platform.clean {stem}
platform.clean :=

# end of file
