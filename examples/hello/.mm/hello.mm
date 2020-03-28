# -*- Makefile -*-
#
# michael a.g. aïvázis
# parasim
# (c) 1998-2020 all rights reserved
#

# show me
# ${info -- hello }

# project meta-data
hello.major := $(repo.major)
hello.minor := $(repo.minor)
hello.micro := $(repo.micro)
hello.revision := $(repo.revision)

# hello builds a python package
hello.packages := hello.pkg
# a library
hello.libraries := hello.lib
# a python extension
hello.extensions := hello.ext
# and a test suite
hello.tests := hello.tst.hello hello.tst.libhello

# the package meta-data
hello.pkg.stem := hello
hello.pkg.drivers := say

# the library meta-data
hello.lib.stem := hello
hello.lib.extern := pyre

# the extension meta-data
hello.ext.stem := hello
hello.ext.pkg := hello.pkg
hello.ext.wraps := hello.lib
hello.ext.capsule :=
hello.ext.extern := hello.lib pyre python


# the libhello test suite
# the C++ library test cases are built implicitlty by considering all source files to be test
# drivers; in this case, there are no command line arguments needed, so mm does not need any
# extra information to build a full testsuite
hello.tst.libhello.stem := libhello
hello.tst.libhello.extern := hello.lib pyre
hello.tst.libhello.prerequisites := hello.lib


# the hello package test suite
# similarly, all source files here are expected to be test drivers; the ones that don't require
# command line arguments do not have to be mentioned as they will be tested implicitly; the
# rest must be dscribed explicitly
hello.tst.hello.stem := hello
hello.tst.hello.prerequisites := hello.pkg hello.ext

# the {say.py} driver does application testing and needs command line arguments, so we have to
# describe test cases
tests.hello.say.cases := say.hello.alec say.hello.ally say.goodbye.matthias
# say hello to alec
say.hello.alec := hello alec
# say hello to ally
say.hello.ally := hello ally
# say goodbye to matthias
say.goodbye.matthias := goodbye mat

# show me
# ${info -- done with hello }

# end of file
