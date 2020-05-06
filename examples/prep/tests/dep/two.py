#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2020 all rights reserved


"""
Step two: open the {pre} data file, and if successful write my own
"""

# externals
import random
import time

# main
if __name__ == "__main__":
    # attempt to
    try:
        # open the input file
        open("pre.dat", mode="r")
    # if this fails
    except FileNotFoundError:
        # warn me
        print(f" ** two: could not open 'pre.dat'")
        # fail
        raise SystemExit(1)

    # otherwise, go to sleep for a while
    time.sleep(5*random.random())
    # write mine
    open("two.dat", mode="w")
    # and indicate success
    raise SystemExit(0)


# end of file
