// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// a greeter knows whom it greets and how
struct Greeter {
    // the person to greet
    let name: String

    /// Build the greeting for {name}
    func greeting() -> String {
        // say hello
        return "hello, \(name)!"
    }
}


// end of file
