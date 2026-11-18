// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// the person to greet is the first argument, if there is one
let name = CommandLine.arguments.dropFirst().first ?? "world"
// make a greeter
let greeter = Greeter(name: name)
// and say hello
print(greeter.greeting())


// end of file
