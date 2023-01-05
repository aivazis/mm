// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2023 all rights reserved
//

// portability
#include <portinfo>
// support
#include <pyre/journal.h>
// friends and greetings
#include <hello/friends/ally.h>
#include <hello/greetings/goodbye.h>

// entry point
int main(int argc, char * argv[]) {
    // initialize the journal
    pyre::journal::init(argc, argv);
    pyre::journal::application("say-goodbye");
    // make a channel
    pyre::journal::debug_t channel("say.goodbye");

    // print a message
    channel
        << pyre::journal::at(__HERE__)
        << hello::goodbye() << " " << hello::ally() << "!"
        << pyre::journal::endl;

    // all done
    return 0;
}

// end of file
