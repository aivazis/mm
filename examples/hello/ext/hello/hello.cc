// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2024 all rights reserved
//

// #include <portinfo>
#include <Python.h>

// the module method declarations
#include "metadata.h"
#include "friends.h"
#include "greetings.h"


// put everything in my private namespace
namespace hello {
    namespace extension {

        // the module method table
        PyMethodDef module_methods[] = {
            // admin
            { copyright__name__, copyright, METH_VARARGS, copyright__doc__ },
            { version__name__, version, METH_VARARGS, version__doc__ },

            // friends
            { alec__name__, alec, METH_VARARGS, alec__doc__ },
            { ally__name__, ally, METH_VARARGS, ally__doc__ },
            { mac__name__, mac, METH_VARARGS, mac__doc__ },
            { mat__name__, mat, METH_VARARGS, mat__doc__ },

            // greetings
            { hello__name__, hello, METH_VARARGS, hello__doc__ },
            { goodbye__name__, goodbye, METH_VARARGS, goodbye__doc__ },

            // sentinel
            { 0, 0, 0, 0 }
        };

        // the module documentation string
        const char * const __doc__ = "an example of a python extension";

        // the module definition structure
        PyModuleDef module_definition = {
            // header
            PyModuleDef_HEAD_INIT,
            // the name of the module
            "hello",
            // the module documentation string
            __doc__,
            // size of the per-interpreter state of the module; -1 if this state is global
            -1,
            // the methods defined in this module
            module_methods
        };

    } // of namespace extension
} // of namespace hello


// initialization function for the module
// *must* be called PyInit_hello
PyMODINIT_FUNC
PyInit_hello()
{
    // create the module
    PyObject * module = PyModule_Create(&hello::extension::module_definition);
    // and return it
    return module;
}

// end of file
