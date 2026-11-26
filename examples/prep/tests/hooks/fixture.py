#!/usr/bin/env python3
# -*- python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
The fixture of the suite is ready before any of its drivers runs
"""

# main
if __name__ == "__main__":
    # attempt to
    try:
        # read the file the fixture writes
        contents = open("fixture.dat", mode="r").read().strip()
    # if it is not there
    except FileNotFoundError:
        # say so
        print(" ** fixture: could not open 'fixture.dat'")
        # and fail
        raise SystemExit(1)

    # check that the fixture finished writing it
    if contents != "ready":
        # say so
        print(f" ** fixture: 'fixture.dat' holds '{contents}' instead of 'ready'")
        # and fail
        raise SystemExit(1)

    # all done
    raise SystemExit(0)


# end of file
