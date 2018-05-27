# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2018 all rights reserved
#

# show me
# ${info -- python2}

# the name of the interpreter
compiler.python = python2
# compute the module suffix
python.suffix.module ?= ${shell $(compiler.python)-config --extension-suffix}
# byte compile
python.compile.base ?= -b

# show me
# ${info -- done with python2}

# end of file
