// -*- C++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once


// support
#include <chrono>
// declarations
#include "forward.h"


// a wall-clock timer with accumulation across multiple start/stop cycles
class timer::Timer {
    // types
public:
    using clock_type = std::chrono::steady_clock;
    using time_point_type = clock_type::time_point;
    using duration_type = std::chrono::duration<double>; // in seconds

    // interface
public:
    // start the timer; no-op if already running
    auto start() -> Timer &;
    // stop the timer and accumulate elapsed time; no-op if not running
    auto stop() -> Timer &;
    // reset the accumulated time and stop the timer
    auto reset() -> Timer &;

    // read the accumulated time in seconds, including any currently running interval
    auto elapsed() const -> double;
    // check whether the timer is currently running
    auto running() const -> bool;

    // special members
public:
    Timer() = default;
    Timer(const Timer &) = default;
    Timer(Timer &&) = default;
    Timer & operator=(const Timer &) = default;
    Timer & operator=(Timer &&) = default;
    ~Timer() = default;

    // data
private:
    bool _running { false };
    time_point_type _start {};
    duration_type _elapsed { 0 };
};


// inline definitions
#include "Timer.icc"


// end of file
