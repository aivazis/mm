# -*- python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


"""
The fixture of a runner suite is in place while its tests run
"""

# externals
import os


def test_fixture():
    """
    The file the fixture writes is there, and the fixture finished writing it
    """
    # read the file the fixture writes
    contents = open("fixture.dat", mode="r").read().strip()
    # check that it is complete
    assert contents == "ready", contents
    # all done
    return


def test_environment():
    """
    The environment of the suite reaches the runner
    """
    # get the location of the fixture from the environment
    fixture = os.environ.get("PREP_FIXTURE")
    # check that the suite set it
    assert fixture == "fixture.dat", fixture
    # all done
    return


# end of file
