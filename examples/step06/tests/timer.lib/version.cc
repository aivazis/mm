// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// portability
#include <portinfo>
// support
#include <pyre/journal.h>
#include <iostream>
// the library
#include <timer/version.h>


int
main(int argc, char * argv[])
{
    // configure journal
    pyre::journal::application("timer.tests");
    pyre::journal::init(argc, argv);

    // get the run-time version
    const auto v = timer::version::version();
    // show me
    std::cout << "version: " << v.major << "." << v.minor << "." << v.micro << " rev "
              << v.revision << std::endl;
    // compile-time constants must match the run-time values; a mismatch means the headers
    // used at compile time don't belong to the shared library that was linked at run time
    if (v.major != timer::version::major || v.minor != timer::version::minor
        || v.micro != timer::version::micro || v.revision != timer::version::revision) {
        // report
        std::cerr << "version mismatch: compile-time headers don't match the shared library"
                  << std::endl;
        // and fail
        return 1;
    }
    // all done
    return 0;
}


// end of file
