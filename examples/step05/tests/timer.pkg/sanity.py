#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
Sanity check: verify the timer package is importable and its public API is present.
"""


def test() -> int:
    """
    Import the package and spot-check the public names.
    """
    # import the package
    import timer

    # verify the public API is reachable; AttributeError here is a meaningful failure
    _ = timer.Timer
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
