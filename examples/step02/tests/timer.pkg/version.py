#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
Verify the package version info is present and show it.
"""


def test() -> int:
    """Print the version and confirm the expected fields are present."""
    # get the metadata module
    import timer.meta as meta
    # show me
    print(f"version: {meta.major}.{meta.minor}.{meta.micro} rev {meta.revision}")
    # all done
    return 0


# main
if __name__ == "__main__":
    status = test()
    raise SystemExit(status)


# end of file
