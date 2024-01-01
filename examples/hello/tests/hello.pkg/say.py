#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# parasim
# (c) 1998-2024 all rights reserved
#


"""
Test the plexus; this driver is very similar to the one in the bin directory
"""

# access the {hello} package
import hello

# main
if __name__ == "__main__":
    # build an instance of the plexus
    app = hello.plexus(name='hello.plexus')
    # and run it
    status = app.run()
    # pass the status on to the shell
    raise SystemExit(status)


# end of file
