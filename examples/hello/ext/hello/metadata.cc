// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2019 all rights reserved
//

// configuration
// #include <portinfo>

// externals
#include <Python.h>
// my declarations
#include "metadata.h"


// copyright
const char * const
hello::extension::
copyright__name__ = "copyright";

const char * const
hello::extension::
copyright__doc__ = "the project copyright string";

PyObject *
hello::extension::
copyright(PyObject *, PyObject *)
{
    // the value
    const char * const copyright_note =
        "hello: (c) 1998-2019 michael a.g. aïvázis <michael.aivazis@para-sim.com>";

    // build a python string and return
    return Py_BuildValue("s", copyright_note);
}


// version
const char * const
hello::extension::
version__name__ = "version";

const char * const
hello::extension::
version__doc__ = "the project version string";

PyObject *
hello::extension::
version(PyObject *, PyObject *)
{
        return Py_BuildValue("s", "4.0");
}


// end of file
