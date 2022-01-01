// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2022 all rights reserved
//

// configuration
#include <portinfo>
// externals
#include <Python.h>
#include <pyre/journal.h>
// my api
#include <hello/hello.h>
// my declarations
#include "greetings.h"


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
    int ok = PyArg_ParseTuple(args, ":hello");
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", hello::hello().data());
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
    int ok = PyArg_ParseTuple(args, ":goodbye");
    // if something went wrong
    if (!ok) {
        // complain
        return 0;
    }

    // all done
    return Py_BuildValue("s", hello::goodbye().data());
}

// end of file
