// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2018 all rights reserved
//

// configuration
// #include <portinfo>
// externals
#include <Python.h>
#include <pyre/journal.h>
// my declarations
#include "hello/hello.h"


// alec
const char * const
hello::extension::
alec__name__ = "alec";

const char * const
hello::extension::
alec__doc__ = "say alec";

PyObject *
hello::extension::
alec(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":alec", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", alec());
}

// ally
const char * const
hello::extension::
ally__name__ = "ally";

const char * const
hello::extension::
ally__doc__ = "say ally";

PyObject *
hello::extension::
ally(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":ally", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", ally());
}

// mac
const char * const
hello::extension::
mac__name__ = "mac";

const char * const
hello::extension::
mac__doc__ = "say mac";

PyObject *
hello::extension::
mac(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":mac", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", mac());
}

// mat
const char * const
hello::extension::
mat__name__ = "mat";

const char * const
hello::extension::
mat__doc__ = "say mat";

PyObject *
hello::extension::
mat(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":mat", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", mat());
}

// end of file
