# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- mpi.init}

# add me to the pile
extern += ${if ${findstring mpi,$(extern)},,mpi}

# users set this variable to communicate which libraries they want
mpi.required ?=

# the location of the binaries
mpi.binpath ?= $(mpi.dir)/bin
# the name of the launcher
mpi.executive ?= mpiexec

# compiler flags
mpi.flags ?=
# enable {mpi} aware code
mpi.defines := \
    WITH_MPI \
    ${if ${findstring mpich,$(mpi.flavor)}, WITH_MPICH,} \
    ${if ${findstring openmpi,$(mpi.flavor)}, WITH_OPENMPI,} \
# the canonical form of the include directory
mpi.incpath ?= $(mpi.dir)/include

# linker flags
mpi.ldflags ?=
# the canonical form of the lib directory
mpi.libpath ?= $(mpi.dir)/lib
# the names of the libraries are flavor dependent
mpi.libraries := \
    ${if ${findstring openmpi,$(mpi.flavor)},mpi_cxx mpi $(mpi.required),}

# show me
# ${info -- done with mpi.init}

# end of file
