// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// external
#include "external.h"
// namespace setup
#include "forward.h"


// bind the {Timer} class
void
timer::py::Timer(py::module & m)
{
    // type alias
    using timer_t = timer::Timer;

    // create the class
    auto cls = py::class_<timer_t>(m, "Timer");

    // constructors
    cls.def(
        // the default constructor
        py::init<>());

    // interface
    cls.def(
        // the name
        "start",
        // the implementation; discard the C++ reference return so Python gets None
        [](timer_t & t) { t.start(); },
        // the docstring
        "start the timer; no-op if already running");

    cls.def(
        "stop", [](timer_t & t) { t.stop(); },
        "stop the timer and accumulate elapsed time; no-op if not running");

    cls.def(
        "reset", [](timer_t & t) { t.reset(); }, "clear the accumulated time and stop the timer");

    // read-only properties
    cls.def_property_readonly(
        // the name
        "elapsed",
        // the getter
        &timer_t::elapsed,
        // the docstring
        "accumulated time in seconds, including any open interval");

    cls.def_property_readonly(
        "running", &timer_t::running, "whether the timer is currently running");

    // all done
    return;
}


// end of file
