#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2022 all rights reserved


"""
Final step: check that all the required files are there
"""


# main
if __name__ == "__main__":
    # make a pile
    requirements = ['pre.dat', 'one.dat', 'two.dat']

    # go through them
    for req in requirements:
        # attempt to
        try:
            # open the file
            open(req, mode="r")
        # if this fails
        except FileNotFoundError:
            # warn me
            print(f" ** post: could not open '{req}'")
            # fail
            raise SystemExit(1)

    # if we get this far, all is good
    raise SystemExit(0)


# end of file
