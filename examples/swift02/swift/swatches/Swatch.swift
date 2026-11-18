// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


/// A color of the asset catalog, known by its name
struct Swatch: Identifiable {
    // the name of the color in the catalog
    let name: String

    // the name tells swatches apart
    var id: String { name }

    // the colors in the catalog, in the order they are shown
    static let all = ["Basalt", "Sandstone", "Lichen", "Glacier", "Ember", "Dusk"].map {
        Swatch(name: $0)
    }
}


// end of file
