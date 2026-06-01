# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# support
import timer


# declaration
class CPP(timer.component, family="timer.timers.cpp", implements=timer.protocols.timer):
    """
    A wall-clock timer backed by the C++ extension.
    """

    # obligations
    @timer.export
    def start(self) -> "CPP":
        """
        Start the timer; no-op if already running.
        """
        self._impl.start()
        return self

    @timer.export
    def stop(self) -> "CPP":
        """
        Stop the timer and accumulate elapsed time; no-op if not running.
        """
        self._impl.stop()
        return self

    @timer.export
    def reset(self) -> "CPP":
        """
        Clear the accumulated time and stop the timer.
        """
        self._impl.reset()
        return self

    # read-only interface
    @property
    def elapsed(self) -> float:
        """
        The accumulated time in seconds, including any currently open interval.
        """
        return self._impl.elapsed

    @property
    def running(self) -> bool:
        """
        Whether the timer is currently running.
        """
        return self._impl.running

    # metamethods
    def __init__(self, **kwds):
        # chain
        super().__init__(**kwds)
        # build the C++ implementation
        from timer.ext import Timer as CppTimer

        self._impl = CppTimer()


# end of file
