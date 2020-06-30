// -*- C++ -*-
//
// michael a.g. aïvázis
// parasim
// (c) 1998-2020 all rights reserved
//

// portability
#include <portinfo>
// support
#include <pyre/journal.h>
// friends and greetings
#include <hello/friends/alec.h>
#include <hello/greetings/hello.h>

// entry point
int main(int argc, char * argv[]) {
    // initialize the journal
    pyre::journal::init(argc, argv);
    pyre::journal::application("say-hello");
    // make a channel
    pyre::journal::debug_t channel("say.hello");

    // print a message
    channel
        << pyre::journal::at(__HERE__)
        << hello::hello() << " " << hello::alec() << "!"
        << pyre::journal::endl;

    // all done
    return 0;
}

// end of file
