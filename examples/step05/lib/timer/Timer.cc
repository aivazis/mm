// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// portability
#include <portinfo>
// my declarations
#include "Timer.h"
// support
#include <pyre/journal.h>


// interface
auto
timer::Timer::start() -> Timer &
{
    // only act if the timer is not already running
    if (!_running) {
        // record the start time
        _start = clock_type::now();
        // mark as running
        _running = true;
        // leave a note
        auto channel = pyre::journal::debug_t("timer.Timer");
        channel << "start" << pyre::journal::endl;
    }
    // all done
    return *this;
}

auto
timer::Timer::stop() -> Timer &
{
    // only act if the timer is actually running
    if (_running) {
        // accumulate the elapsed time for this interval
        _elapsed += clock_type::now() - _start;
        // mark as stopped
        _running = false;
        // leave a note
        auto channel = pyre::journal::debug_t("timer.Timer");
        channel << "stop" << pyre::journal::endl;
    }
    // all done
    return *this;
}

auto
timer::Timer::reset() -> Timer &
{
    // stop the timer
    _running = false;
    // clear accumulated time
    _elapsed = duration_type { 0 };
    // leave a note
    auto channel = pyre::journal::debug_t("timer.Timer");
    channel << "reset" << pyre::journal::endl;
    // all done
    return *this;
}


// end of file
