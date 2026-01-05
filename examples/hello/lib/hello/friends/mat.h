// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2026 all rights reserved
//

// declare the fortran implementation
extern "C" {
    const char * mat();
}

namespace hello {
    // mat
    inline auto mat() { return ::mat(); }
}

// end of file
