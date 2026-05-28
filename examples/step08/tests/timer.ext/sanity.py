#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
Sanity check: verify the timer extension is importable and its public API is present.
"""


def test() -> int:
    """
    Import the extension and spot-check the expected names.
    """
    # import the extension module
    from timer.ext import timer as ext

    # verify the public API is reachable
    _ = ext.Timer
    _ = ext.version
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
