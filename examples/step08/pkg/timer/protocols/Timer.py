# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# support
import timer


# declaration
class Timer(timer.protocol, family="timer.protocols.timer"):
    """
    The requirements for a wall-clock timer.
    """

    # obligations
    @timer.provides
    def start(self):
        """
        Start the timer; no-op if already running.
        """

    @timer.provides
    def stop(self):
        """
        Stop the timer and accumulate elapsed time; no-op if not running.
        """

    @timer.provides
    def reset(self):
        """
        Clear the accumulated time and stop the timer.
        """

    # the default implementation: C++ backed if available, pure Python otherwise
    @classmethod
    def pyre_default(cls, **kwds):
        """
        Return the best available timer implementation.
        """
        # attempt to
        try:
            # get the C++ backed component
            from timer.ext import CPP

            # and return it as the default
            return CPP
        # if the extension is not available
        except ImportError:
            # fall back to the pure Python implementation
            from timer import Timer

            return Timer


# end of file
