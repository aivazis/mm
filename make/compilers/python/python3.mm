# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- python3}

# the name of the interpreter
compiler.python ?= python3
# compute the module suffix
python.suffix.module ?= ${shell $(compiler.python)-config --extension-suffix}
# byte compile
python.compile.base ?= -m compileall -b -q

# compile
python.compile := $(compiler.python) $(python.compile.base)

# show me
# ${info -- done with python3}

# end of file
