# -*- Makefile -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2022 all rights reserved


# show me
# ${info -- python3}

# register {python3} as the python compiler
compiler.python ?= python3

# the name of the executable
python3.driver ?= python3

# compute the module suffix
python3.suffix.module ?= ${shell $(python3.driver)-config --extension-suffix}
# byte compile
python3.compile.base ?= -m compileall -b -q

# compile
python3.compile := $(python3.driver) $(python3.compile.base)

# show me
# ${info -- done with python3}

# end of file
