#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2024 all rights reserved


"""
Prep the testsuite
"""


# main
if __name__ == "__main__":
    # simple stuff: create a "data" file that other tests depend on
    open("pre.dat", mode="w")
    # and indicate success
    raise SystemExit(0)


# end of file
