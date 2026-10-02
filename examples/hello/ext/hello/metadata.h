// -*- c++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once


// place everything in my private namespace
namespace hello { namespace extension {

    // copyright note
    extern const char * const copyright__name__;
    extern const char * const copyright__doc__;
    PyObject * copyright(PyObject *, PyObject *);

    // version
    extern const char * const version__name__;
    extern const char * const version__doc__;
    PyObject * version(PyObject *, PyObject *);

}} // namespace hello::extension


// end of file
