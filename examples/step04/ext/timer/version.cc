// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// external
#include "external.h"
// namespace setup
#include "forward.h"


// add a {version} submodule that exposes both compile-time and run-time version info
void
timer::py::version(py::module & m)
{
    // make the submodule
    auto version = m.def_submodule(
        // its name
        "version",
        // its docstring
        "the static and dynamic version of the extension");

    // static version: values baked in from the headers at compile time
    version.def(
        // the name
        "static",
        // the implementation
        []() {
            return std::make_tuple(
                timer::version::major, timer::version::minor, timer::version::micro,
                timer::version::revision);
        },
        // the docstring
        "the timer version visible at compile time");

    // dynamic version: values provided by the shared library at run time
    version.def(
        // the name
        "dynamic",
        // the implementation
        []() {
            // ask the shared library
            const auto v = timer::version::version();
            // pack into a tuple
            return std::make_tuple(v.major, v.minor, v.micro, v.revision);
        },
        // the docstring
        "the timer version visible through the shared library");

    // all done
    return;
}


// end of file
