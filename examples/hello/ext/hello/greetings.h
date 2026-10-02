// -*- c++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once


// place everything in my private namespace
namespace hello { namespace extension {

    // hello: say hello
    extern const char * const hello__name__;
    extern const char * const hello__doc__;
    PyObject * hello(PyObject *, PyObject *);

    // goodbye: say goodbye
    extern const char * const goodbye__name__;
    extern const char * const goodbye__doc__;
    PyObject * goodbye(PyObject *, PyObject *);

}} // namespace hello::extension


// end of file
