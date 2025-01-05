// -*- c++ -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2025 all rights reserved


// externals
#include "external.h"
// namespace setup
#include "forward.h"
// bindings
#include "__init__.h"


// add global bindings to the module
void
simple::py::api(py::module & m)
{
    // get the version
    m.def(
        // the name
        "version",
        // the implementation
        &simple::version,
        // the docstring
        "initialize the hdf5 runtime");

    // all done
    return;
}


// end of file
