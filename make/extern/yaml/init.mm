# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2023 all rights reserved
#

# show me
# ${info -- yaml.init}

# add me to the pile
extern += ${if ${findstring yaml,$(extern)},,yaml}

# find my configuration file
yaml.config := ${dir ${call extern.config,yaml}}

# the flavor
yaml.flavor ?= -cpp
# compiler flags
yaml.flags ?=
# enable {yaml} aware code
yaml.defines := WITH_YAML
# the canonical form of the include directory
yaml.incpath ?= $(yaml.dir)/include

# linker flags
yaml.ldflags ?=
# the canonical form of the lib directory
yaml.libpath ?= $(yaml.dir)/lib
# the name of the library
yaml.libraries := yaml$(yaml.flavor)

# initialize the list of my dependencies
yaml.dependencies =

# show me
# ${info -- done with yaml.init}

# end of file
