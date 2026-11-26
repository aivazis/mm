#!/usr/bin/env python3
# -*- python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
The environment of the suite reaches each of its drivers
"""

# externals
import os

# main
if __name__ == "__main__":
    # get the location of the fixture from the environment
    fixture = os.environ.get("PREP_FIXTURE")
    # check that it was set by the suite
    if fixture != "fixture.dat":
        # say so
        print(f" ** environment: PREP_FIXTURE is '{fixture}' instead of 'fixture.dat'")
        # and fail
        raise SystemExit(1)

    # all done
    raise SystemExit(0)


# end of file
