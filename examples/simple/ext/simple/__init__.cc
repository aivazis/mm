// -*- c++ -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2025 all rights reserved


// external dependencies
#include "external.h"
// namespace setup
#include "forward.h"

// my package declarations
#include "__init__.h"

// the module entry point
PYBIND11_MODULE(simple, m)
{
    // the docstring
    m.doc() = "the simple extension module";

    // register the module api
    simple::py::api(m);

    // all done
    return;
}


// end of file
