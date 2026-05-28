#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
Verify the static and dynamic versions are consistent and print both.
"""

# support
import sys

# the extension
from timer.ext import timer as ext


def test() -> int:
    """
    Compare the compile-time and run-time version tuples.
    """
    # query both
    static = ext.version.static()
    dynamic = ext.version.dynamic()
    # show me
    print(f"static:  {static[0]}.{static[1]}.{static[2]} rev {static[3]}")
    print(f"dynamic: {dynamic[0]}.{dynamic[1]}.{dynamic[2]} rev {dynamic[3]}")
    # they must agree; a mismatch means the headers and shared library are out of sync
    if static != dynamic:
        print("FAILED: static and dynamic versions don't match", file=sys.stderr)
        return 1
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
