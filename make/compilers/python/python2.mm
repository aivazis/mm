# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2021 all rights reserved
#

# show me
# ${info -- python2}

# register {python2} as the python compiler
compiler.python := python2

# hardwire the module suffix; {python2-config} doesn't cover this
python.suffix.module ?= .module.so
# byte compile
python.compile.base ?= -m compileall -b -q

# compile
python.compile := $(compiler.python) $(python.compile.base)

# show me
# ${info -- done with python2}

# end of file
