#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved

# support
import sys
import time

# the package
from timer import Timer


def test() -> int:
    """
    Verify that elapsed time is positive after a start/stop cycle.
    """
    t = Timer()
    t.start()
    # sleep long enough that perf_counter records non-zero elapsed time
    time.sleep(0.01)
    t.stop()
    # the elapsed time must be strictly positive
    if t.elapsed <= 0.0:
        print(
            "FAILED: elapsed time should be positive after start()/stop()",
            file=sys.stderr,
        )
        return 1
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
