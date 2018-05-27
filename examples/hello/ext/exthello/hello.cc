// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2018 all rights reserved
//

#include <portinfo>
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

            // sentinel
            { 0, 0, 0, 0 }
        };

        // the module documentation string
        const char * const __doc__ = "sample project documentation string";

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
