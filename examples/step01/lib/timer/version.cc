// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// my declarations
#include "version.h"


// build and return the version struct
auto
timer::version::version() -> version_t
{
    return { major, minor, micro, revision };
}


// end of file
