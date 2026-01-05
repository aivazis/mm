// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2026 all rights reserved
//

#if !defined(hello_extension_friends_h)
#define hello_extension_friends_h


// place everything in my private namespace
namespace hello {
    namespace extension {

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

    } // of namespace extension`
} // of namespace hello

#endif

// end of file
