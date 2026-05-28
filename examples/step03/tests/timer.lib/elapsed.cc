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
    // burn enough cycles that steady_clock records non-zero elapsed time
    volatile int dummy = 0;
    for (int i = 0; i < 1'000'000; ++i) {
        dummy += i;
    }
    t.stop();
    // the elapsed time must be strictly positive
    if (t.elapsed() <= 0.0) {
        std::cerr << "FAILED: elapsed time should be positive after start()/stop()" << std::endl;
        return 1;
    }
    // all done
    return 0;
}


// end of file
