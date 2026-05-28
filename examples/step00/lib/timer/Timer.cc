// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// my declarations
#include "Timer.h"


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
    // all done
    return *this;
}


// end of file
