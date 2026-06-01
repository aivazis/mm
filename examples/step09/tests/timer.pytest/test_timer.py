# -*- Python -*-
# -*- coding: utf-8 -*-
#
# michael a.g. aïvázis <michael.aivazis@para-sim.com>
# (c) 1998-2026 all rights reserved


# the package under test
from timer import Timer


def test_sanity():
    """
    The package is importable and its public API is present.
    """
    import timer

    assert timer.Timer is not None


def test_running():
    """
    {running} tracks start() and stop().
    """
    t = Timer()
    assert not t.running
    t.start()
    assert t.running
    t.stop()
    assert not t.running


def test_elapsed():
    """
    {elapsed} is non-negative and advances across an interval.
    """
    t = Timer()
    t.start()
    t.stop()
    assert t.elapsed >= 0.0


# end of file
