// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// the library
#include <timer/Timer.h>


int
main()
{
    // a freshly constructed timer is not running
    timer::Timer t;
    if (t.running()) {
        return 1;
    }
    // it is running after start()
    t.start();
    if (!t.running()) {
        return 1;
    }
    // and not running again after stop()
    t.stop();
    if (t.running()) {
        return 1;
    }
    // all done
    return 0;
}


// end of file
