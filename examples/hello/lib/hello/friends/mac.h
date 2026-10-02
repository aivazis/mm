// -*- c++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once


// declare the C implementation
extern "C" {
const char *
mac();
}

namespace hello {
    // mac
    inline auto mac()
    {
        return ::mac();
    }
} // namespace hello


// end of file
