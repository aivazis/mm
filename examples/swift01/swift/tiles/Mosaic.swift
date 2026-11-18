// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import Observation


/// A grid of square tiles, and the scale at which the screen shows them
@MainActor
@Observable
final class Mosaic {
    // the shape of the grid
    let rows: Int
    let columns: Int
    // the scale of the display; one shows each tile at its natural size
    var scale: Double = 1

    // the range the scale is kept in
    static let smallest = 0.25
    static let largest = 4.0

    /// Make a mosaic of {rows} by {columns} tiles
    init(rows: Int, columns: Int) {
        // record the shape
        self.rows = rows
        self.columns = columns
    }

    /// Set the scale to {value}, kept within the allowed range
    func zoom(to value: Double) {
        // clip the request and record it
        scale = min(max(value, Mosaic.smallest), Mosaic.largest)
    }

    /// The hue of the tile at {row} and {column}, as a fraction of the color wheel
    nonisolated static func hue(row: Int, column: Int) -> Double {
        // walk the wheel along both axes at different rates, so neighbors differ
        return Double((7 * row + 3 * column) % 32) / 32
    }
}


// end of file
