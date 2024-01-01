# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2024 all rights reserved
#


# access the pyre framework
import pyre
# my protocol
from .Action import Action as action


# class declaration
class Command(pyre.panel(), implements=action):
    """
    Base class for {hello} commands
    """


# end of file
