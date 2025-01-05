// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2025 all rights reserved
//


// configuration
#include <portinfo>
// externals
#include <string>
#include <pyre/journal.h>
// declarations
#include "alec.h"

// friends
std::string hello::alec() {
    // make a channel
    pyre::journal::debug_t channel("hello.friends");
    // show me
    channel
        << pyre::journal::at(__HERE__)
        << "friend: Alec"
        << pyre::journal::endl;

    // easy enough
    return "Alec";
}

// end of file
