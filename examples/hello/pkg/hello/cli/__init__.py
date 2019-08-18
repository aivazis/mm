# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2019 all rights reserved
#


# pull in the command decorators
from .. import foundry, action

# help
@foundry(implements=action, tip="display information about this application")
def about():
    """
    Display information about this application
    """
    # pull the command
    from .About import About
    # steal its docstring
    __doc__ = About.__doc__
    # and publish it
    return About


@foundry(implements=action, tip="display information about the layout of this application")
def config():
    """
    Display information about this application
    """
    # pull the command
    from .Config import Config
    # steal its docstring
    __doc__ = Config.__doc__
    # and publish it
    return Config


# hello
@foundry(implements=action, tip="compute the result of an operation")
def hello():
    """
    Say "hello" to a friend
    """
    # pull the command
    from .Hello import Hello
    # steal its docstring
    __doc__ = Hello.__doc__
    # and publish it
    return Hello


# goodbye
@foundry(implements=action, tip="compute the result of an operation")
def goodbye():
    """
    Say "goodbye" to a friend
    """
    # pull the command
    from .Goodbye import Goodbye
    # steal its docstring
    __doc__ = Goodbye.__doc__
    # and publish it
    return Goodbye


# end of file
