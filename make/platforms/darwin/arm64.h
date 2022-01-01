// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2022 all rights reserved
//

#if !defined(mm_platforms_darwin_arm64)
// user code can use the code guard to know the specific architecture
#define mm_platforms_darwin_arm64
// also, more generally
#define mm_platforms_darwin

/* system calls */
#define HAVE_SYSCTL 1
/* cpu count and geometry through "hw.xxxx" */
#define HAVE_SYSCTL_HW_DOT 1

#endif

// end of file
