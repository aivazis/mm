// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2023 all rights reserved
//

// declare the C implementation
extern "C" {
    const char * mac();
}

namespace hello {
    // mac
    inline auto mac() { return ::mac(); }
}

// end of file
