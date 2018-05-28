# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2018 all rights reserved
#


# pull in the command decorators
from .. import foundry, action

# help
@foundry(implements=action, tip="display information about this application")
def about():
    """
    Display information about this application
    """
    from .About import About
    return About


# hello
@foundry(implements=action, tip="compute the result of an operation")
def hello():
    """
    Say "hello" to a friend
    """
    from .Hello import Hello
    return Hello


# goodbye
@foundry(implements=action, tip="compute the result of an operation")
def goodbye():
    """
    Say "goodbye" to a friend
    """
    from .Goodbye import Goodbye
    return Goodbye


# end of file
