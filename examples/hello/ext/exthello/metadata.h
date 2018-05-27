// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2018 all rights reserved
//

#if !defined(hello_extension_metadata_h)
#define hello_extension_metadata_h


// place everything in my private namespace
namespace hello {
    namespace extension {

        // copyright note
        extern const char * const copyright__name__;
        extern const char * const copyright__doc__;
        PyObject * copyright(PyObject *, PyObject *);

        // version
        extern const char * const version__name__;
        extern const char * const version__doc__;
        PyObject * version(PyObject *, PyObject *);

    } // of namespace extension`
} // of namespace hello

#endif

// end of file
