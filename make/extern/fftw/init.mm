# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- fftw.init}

# add me to the pile
extern += ${if ${findstring fftw,$(extern)},,fftw}

# the flavor: single or double precision
fftw.flavor =? f

# compiler flags
fftw.flags ?=
# enable {fftw} aware code
fftw.defines := WITH_FFTW
# the canonical form of the include directory
fftw.incpath ?= $(fftw.dir)/include

# linker flags
fftw.ldflags ?=
# the canonical form of the lib directory
fftw.libpath ?= $(fftw.dir)/lib
# the name of the library is flavor dependent
fftw.libraries := fftw$(fftw.flavor)

# my dependencies
fftw.dependencies =

# show me
# ${info -- done with fftw.init}

# end of file
