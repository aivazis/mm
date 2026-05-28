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
    """Verify that reset() clears elapsed time and stops the timer."""
    t = Timer()
    t.start()
    time.sleep(0.01)
    t.stop()
    # reset clears both the accumulated time and the running flag
    t.reset()
    if t.running:
        print("FAILED: timer should not be running after reset()", file=sys.stderr)
        return 1
    if t.elapsed != 0.0:
        print("FAILED: elapsed time should be zero after reset()", file=sys.stderr)
        return 1
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
