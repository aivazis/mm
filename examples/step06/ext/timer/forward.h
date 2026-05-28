// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once

// get the external declarations
#include "external.h"

// the {timer::py} namespace
namespace timer::py {
    // the version submodule
    void version(py::module &);
    // the Timer class
    void Timer(py::module &);
} // namespace timer::py


// end of file
