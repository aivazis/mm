// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// the framework
#include <catch2/catch_test_macros.hpp>
// the library under test
#include <timer/Timer.h>


TEST_CASE("running tracks start and stop", "[running]")
{
    timer::Timer t;
    // a freshly constructed timer is not running
    REQUIRE_FALSE(t.running());
    // it is running after start()
    t.start();
    REQUIRE(t.running());
    // and not running again after stop()
    t.stop();
    REQUIRE_FALSE(t.running());
}


// end of file
