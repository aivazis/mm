# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2025 all rights reserved

# add to extern list unless already present
extern += ${if ${findstring libtorch,$(extern)},,libtorch}

# # find my configuration file
libtorch.config := ${dir ${call extern.config,libtorch}}


# compiler flags
libtorch.flags ?=
# enable {libtorch} aware code
libtorch.defines ?= WITH_TORCH
# include path (PyTorch uses nested include/torch/csrc)
libtorch.incpath ?= $(libtorch.dir)/include $(libtorch.dir)/include/torch/csrc/api/include

# linker flags
libtorch.ldflags ?=
# the canonical form of the lib directory
libtorch.libpath ?= $(libtorch.dir)/lib
# its rpath
libtorch.rpath = $(libtorch.libpath)
# the names of the libraries
libtorch.libraries ?= torch torch_cpu c10

# my dependencies
libtorch.dependencies :=

# end of file
