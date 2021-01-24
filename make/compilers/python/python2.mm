# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- python2}

# the name of the interpreter
compiler.python = python2
# compute the module suffix
python.suffix.module ?= ${shell $(compiler.python)-config --extension-suffix}
# byte compile
python.compile.base ?= -m compileall -b -q

# compile
python.compile := $(compiler.python) $(python.compile.base)

# show me
# ${info -- done with python2}

# end of file
