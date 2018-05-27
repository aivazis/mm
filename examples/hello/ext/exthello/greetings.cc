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


// hello
const char * const
hello::extension::
hello__name__ = "hello";

const char * const
hello::extension::
hello__doc__ = "say hello";

PyObject *
hello::extension::
hello(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":hello", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", hello());
}

// goodbye
const char * const
hello::extension::
goodbye__name__ = "goodbye";

const char * const
hello::extension::
goodbye__doc__ = "say goodbye";

PyObject *
hello::extension::
goodbye(PyObject *, PyObject * args)
{
    // parse the arguments
    int ok = PyArg_ParseTuple(args, ":goodbye", &size);
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", goodbye());
}

// end of file
