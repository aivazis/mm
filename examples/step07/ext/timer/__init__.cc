// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// portability
#include <portinfo>
// external
#include "external.h"
// namespace setup
#include "forward.h"
// sub-namespace initializers
#include "__init__.h"


// the module entry point
PYBIND11_MODULE(timer, m)
{
    // the doc string
    m.doc() = "the timer C++ extension module";

    // version info
    timer::py::version(m);
    // the Timer class
    timer::py::Timer(m);
}


// end of file
