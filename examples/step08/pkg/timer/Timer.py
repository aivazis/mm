# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# support
import time
import timer


# declaration
class Timer(
    timer.component, family="timer.timers.python", implements=timer.protocols.timer
):
    """
    A wall-clock timer backed by time.perf_counter.
    """

    # obligations
    @timer.export
    def start(self) -> "Timer":
        """
        Start the timer; no-op if already running.
        """
        if not self._running:
            self._start = time.perf_counter()
            self._running = True
        return self

    @timer.export
    def stop(self) -> "Timer":
        """
        Stop the timer and accumulate elapsed time; no-op if not running.
        """
        if self._running:
            self._elapsed += time.perf_counter() - self._start
            self._running = False
        return self

    @timer.export
    def reset(self) -> "Timer":
        """
        Clear the accumulated time and stop the timer.
        """
        self._running = False
        self._elapsed = 0.0
        return self

    # read-only interface
    @property
    def elapsed(self) -> float:
        """
        The accumulated time in seconds, including any currently open interval.
        """
        total = self._elapsed
        if self._running:
            total += time.perf_counter() - self._start
        return total

    @property
    def running(self) -> bool:
        """
        Whether the timer is currently running.
        """
        return self._running

    # metamethods
    def __init__(self, **kwds):
        # chain
        super().__init__(**kwds)
        # state
        self._running: bool = False
        self._start: float = 0.0
        self._elapsed: float = 0.0


# end of file
