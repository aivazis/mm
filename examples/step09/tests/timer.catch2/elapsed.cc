// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// the framework
#include <catch2/catch_test_macros.hpp>
// the library under test
#include <timer/Timer.h>


TEST_CASE("elapsed is positive across an interval", "[elapsed]")
{
    timer::Timer t;
    t.start();
    // burn enough cycles that steady_clock records non-zero elapsed time
    volatile int dummy = 0;
    for (int i = 0; i < 1'000'000; ++i) {
        dummy += i;
    }
    t.stop();
    // the accumulated time must be strictly positive
    REQUIRE(t.elapsed() > 0.0);
}


// end of file
