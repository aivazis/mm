// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once

// pybind11 support
#include <pybind11/pybind11.h>
#include <pybind11/stl.h>

// the timer library
#include <timer/public.h>

// type aliases
namespace timer::py {
    // pull in pybind11
    namespace py = pybind11;
    // get the special {pybind11} literals
    using namespace py::literals;
    // strings
    using string_t = std::string;
} // namespace timer::py


// end of file
