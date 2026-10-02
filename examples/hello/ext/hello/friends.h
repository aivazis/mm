// -*- c++ -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved

// code guard
#pragma once


// place everything in my private namespace
namespace hello { namespace extension {

    // alec
    extern const char * const alec__name__;
    extern const char * const alec__doc__;
    PyObject * alec(PyObject *, PyObject *);

    // ally
    extern const char * const ally__name__;
    extern const char * const ally__doc__;
    PyObject * ally(PyObject *, PyObject *);

    // mac
    extern const char * const mac__name__;
    extern const char * const mac__doc__;
    PyObject * mac(PyObject *, PyObject *);

    // mat
    extern const char * const mat__name__;
    extern const char * const mat__doc__;
    PyObject * mat(PyObject *, PyObject *);

}} // namespace hello::extension


// end of file
