// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// my declarations
#include "version.h"


// build and return the version tuple
auto
timer::version() -> version_type
{
    return { major_version, minor_version, micro_version, revision };
}


// end of file
