# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved

# support
import time


class Timer:
    """
    A wall-clock timer backed by time.perf_counter.
    """

    def __init__(self, **kwds):
        # chain
        super().__init__(**kwds)
        # state
        self._running: bool = False
        self._start: float = 0.0
        self._elapsed: float = 0.0

    def start(self) -> "Timer":
        """
        Start the timer; no-op if already running.
        """
        if not self._running:
            self._start = time.perf_counter()
            self._running = True
        return self

    def stop(self) -> "Timer":
        """
        Stop the timer and accumulate elapsed time; no-op if not running.
        """
        if self._running:
            self._elapsed += time.perf_counter() - self._start
            self._running = False
        return self

    def reset(self) -> "Timer":
        """
        Clear the accumulated time and stop the timer.
        """
        self._running = False
        self._elapsed = 0.0
        return self

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


# end of file
