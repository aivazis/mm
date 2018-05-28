# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2018 all rights reserved
#


# superclass
from .Greet import Greet


# declaration
class Goodbye(Greet, family='hello.actions.goodbye'):
    """
    Say "goodbye" to a friend
    """


    # my greeting
    greeting = hello.ext.libhello.goodbye()


# end of file
