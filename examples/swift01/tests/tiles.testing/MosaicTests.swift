// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import Testing


/// A request for a scale below the smallest one settles on the smallest
@Test @MainActor func zoomStopsAtTheSmallestScale() {
    // make a mosaic
    let mosaic = Mosaic(rows: 4, columns: 4)
    // ask for a scale far below the range
    mosaic.zoom(to: 0.01)
    // and check it was clipped
    #expect(mosaic.scale == Mosaic.smallest)
}

/// A request for a scale above the largest one settles on the largest
@Test @MainActor func zoomStopsAtTheLargestScale() {
    // make a mosaic
    let mosaic = Mosaic(rows: 4, columns: 4)
    // ask for a scale far above the range
    mosaic.zoom(to: 100)
    // and check it was clipped
    #expect(mosaic.scale == Mosaic.largest)
}

/// A request for a scale within the range is granted as it is
@Test @MainActor func zoomGrantsScalesWithinTheRange() {
    // make a mosaic
    let mosaic = Mosaic(rows: 4, columns: 4)
    // ask for a scale inside the range
    mosaic.zoom(to: 1.5)
    // and check it was recorded unchanged
    #expect(mosaic.scale == 1.5)
}

/// Every tile has a hue on the color wheel
@Test func huesStayOnTheWheel() {
    // visit the tiles of a large mosaic
    for row in 0..<64 {
        for column in 0..<64 {
            // and check that each hue is a fraction of a turn
            let hue = Mosaic.hue(row: row, column: column)
            #expect(hue >= 0 && hue < 1)
        }
    }
}


// end of file
