// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import SwiftUI


/// The application: a single window that shows the named colors of its asset catalog
@main
struct SwatchesApp: App {
    // the window and its contents
    var body: some Scene {
        WindowGroup {
            SwatchesView()
        }
    }
}


// end of file
