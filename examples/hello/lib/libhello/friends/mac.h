// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2018 all rights reserved
//

// declare the C implementation
extern "C" {
    const char * mac();
}

namespace hello {
    // mac
    inline const char * mac() { return ::mac(); }
}

// end of file
