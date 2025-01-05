# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2025 all rights reserved
#


# my package
import hello
# superclass
from .Greet import Greet


# declaration
class Hello(Greet, family='hello.cli.hello'):
    """
    Say "hello" to a friend
    """


    # my greeting
    greeting = hello.ext.libhello.hello()


# end of file
