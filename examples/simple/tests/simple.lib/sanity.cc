// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2024 all rights reserved

// externals
#include <iostream>

// support
#include <simple/version.h>

// the driver
int
main()
{
    // get the version
    const auto [major, minor, micro, revision] = simple::version();
    // show me
    std::cout << "version: " << major << "." << minor << "." << micro << " rev " << revision
              << std::endl;
    // all done
    return 0;
}

// end of file