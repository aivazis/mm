# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# publish pyre symbols so client code uses {timer.protocol}, {timer.component}, etc.
from pyre import (
    protocol,
    component,
    provides,
    export,
    properties,
    application,
    executive,
)

# register with the framework so pyre can find our config files and share directory
package = executive.registerPackage(name="timer", file=__file__)
home, prefix, defaults = package.layout()

# publish the local modules
from . import meta
from . import protocols

# the timer implementations
from .Timer import Timer

# end of file
