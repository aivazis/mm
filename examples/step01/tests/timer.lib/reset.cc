// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// support
#include <iostream>
// the library
#include <timer/Timer.h>


int
main()
{
    timer::Timer t;
    t.start();
    // burn some cycles so elapsed is non-zero before the reset
    volatile int dummy = 0;
    for (int i = 0; i < 1'000'000; ++i) {
        dummy += i;
    }
    t.stop();
    // reset clears the accumulated time and the running flag
    t.reset();
    if (t.running()) {
        std::cerr << "FAILED: timer should not be running after reset()" << std::endl;
        return 1;
    }
    if (t.elapsed() != 0.0) {
        std::cerr << "FAILED: elapsed time should be zero after reset()" << std::endl;
        return 1;
    }
    // all done
    return 0;
}


// end of file
