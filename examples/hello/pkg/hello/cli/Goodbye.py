# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2026 all rights reserved
#


# my package
import hello
# superclass
from .Greet import Greet


# declaration
class Goodbye(Greet, family='hello.cli.goodbye'):
    """
    Say "goodbye" to a friend
    """


    # my greeting
    greeting = hello.ext.libhello.goodbye()


# end of file
