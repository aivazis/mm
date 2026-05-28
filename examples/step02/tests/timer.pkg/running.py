#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved

# support
import sys

# the package
from timer import Timer


def test() -> int:
    """Verify that running transitions correctly across start() and stop()."""
    t = Timer()
    # a freshly constructed timer is not running
    if t.running:
        print("FAILED: timer should not be running after construction", file=sys.stderr)
        return 1
    # it is running after start()
    t.start()
    if not t.running:
        print("FAILED: timer should be running after start()", file=sys.stderr)
        return 1
    # and not running again after stop()
    t.stop()
    if t.running:
        print("FAILED: timer should not be running after stop()", file=sys.stderr)
        return 1
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
