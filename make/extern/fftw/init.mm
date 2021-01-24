# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- fftw.init}

# add me to the pile
extern += ${if ${findstring fftw,$(extern)},,fftw}

# the flavor: version, and single or double precision
fftw.flavor ?= 3 # other valid choices: 3_threads 3f 3f_threads 3l 3l_threads

# compiler flags
fftw.flags ?=
# enable {fftw} aware code
fftw.defines := WITH_FFTW WITH_FFTW3
# the canonical form of the include directory
fftw.incpath ?= $(fftw.dir)/include

# linker flags
fftw.ldflags ?=
# the canonical form of the lib directory
fftw.libpath ?= $(fftw.dir)/lib
# the name of the library is flavor dependent
fftw.libraries := ${addprefix fftw,$(fftw.flavor)}

# my dependencies
fftw.dependencies =

# show me
# ${info -- done with fftw.init}

# end of file
