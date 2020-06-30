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
hello.tests := hello.tests.hello.pkg hello.tests.hello.lib

# the package meta-data
hello.pkg.stem := hello
hello.pkg.drivers := say

# the library meta-data
hello.lib.stem := hello
hello.lib.extern := pyre
hello.lib.c++.flags += $($(compiler.c++).std.c++17)

# the extension meta-data
hello.ext.stem := hello
hello.ext.pkg := hello.pkg
hello.ext.wraps := hello.lib
hello.ext.capsule :=
hello.ext.extern := hello.lib pyre python
hello.ext.lib.c++.flags += $($(compiler.c++).std.c++17)


# the libhello test suite
# the C++ library test cases are built implicitlty by considering all source files to be test
# drivers; in this case, there are no command line arguments needed, so mm does not need any
# extra information to build a full testsuite
hello.tests.hello.lib.stem := hello.lib
hello.tests.hello.lib.extern := hello.lib pyre
hello.tests.hello.lib.prerequisites := hello.lib

# c++ compiler arguments
hello.tests.hello.lib.flags += -Wall $($(compiler.c++).std.c++17)

# the hello package test suite
# similarly, all source files here are expected to be test drivers; the ones that don't require
# command line arguments do not have to be mentioned as they will be tested implicitly; the
# rest must be dscribed explicitly
hello.tests.hello.pkg.stem := hello.pkg
hello.tests.hello.pkg.prerequisites := hello.pkg hello.ext

# the {say.py} driver does application testing and needs command line arguments, so we have to
# describe test cases
tests.hello.pkg.say.cases := say.hello.alec say.hello.mac say.hello.ally say.goodbye.matthias
# say hello to alec
say.hello.alec.argv := hello alec
# say hello to ally
say.hello.ally.argv := hello ally
# say hello to mac
say.hello.mac.argv := hello mac
# say goodbye to matthias
say.goodbye.matthias.argv := goodbye mat

# show me
# ${info -- done with hello }

# end of file
