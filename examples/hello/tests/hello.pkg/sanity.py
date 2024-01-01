#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2024 all rights reserved
#


"""
Sanity check: verify that the {hello} package is accessible
"""


def test():
    # access the {hello} package
    import hello
    # all done
    return 0


# main
if __name__ == "__main__":
    # do...
    status = test()
    # share
    raise SystemExit(status)



# end of file
