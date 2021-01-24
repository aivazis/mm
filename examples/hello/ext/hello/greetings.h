// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2021 all rights reserved
//

#if !defined(hello_extension_greetings_h)
#define hello_extension_greetings_h


// place everything in my private namespace
namespace hello {
    namespace extension {

        // hello: say hello
        extern const char * const hello__name__;
        extern const char * const hello__doc__;
        PyObject * hello(PyObject *, PyObject *);

        // goodbye: say goodbye
        extern const char * const goodbye__name__;
        extern const char * const goodbye__doc__;
        PyObject * goodbye(PyObject *, PyObject *);

    } // of namespace extension`
} // of namespace hello

#endif

// end of file
