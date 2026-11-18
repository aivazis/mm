// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import SwiftUI


/// Draw a mosaic in a canvas that scrolls in both directions and scales with a pinch, and show
/// the scale it is drawn at
struct MosaicView: View {
    // the mosaic, kept for as long as the view lives
    @State private var mosaic = Mosaic(rows: 64, columns: 64)
    // the scale when the pinch in progress started
    @State private var baseline = 1.0

    // the side of a tile at unit scale, in points
    private let side = 64.0

    // the contents
    var body: some View {
        // the side of a tile at the current scale
        let tile = side * mosaic.scale
        // the drawing reads plain values, so it owns nothing that the main actor guards
        let rows = mosaic.rows
        let columns = mosaic.columns

        // the canvas, in a view that scrolls both ways
        ScrollView([.horizontal, .vertical]) {
            Canvas { context, _ in
                // fill each tile with its color, inset to leave a seam between neighbors
                for row in 0..<rows {
                    for column in 0..<columns {
                        // where the tile goes
                        let frame = CGRect(
                            x: Double(column) * tile, y: Double(row) * tile,
                            width: tile, height: tile)
                        // its color
                        let color = Color(
                            hue: Mosaic.hue(row: row, column: column),
                            saturation: 0.6, brightness: 0.8)
                        // and the paint
                        context.fill(Path(frame.insetBy(dx: 1, dy: 1)), with: .color(color))
                    }
                }
            }
            // the canvas is as large as the mosaic at the current scale
            .frame(width: tile * Double(columns), height: tile * Double(rows))
        }
        // a pinch scales the mosaic relative to where the pinch started; the scroll view has
        // gestures of its own, so the pinch is recognized alongside them rather than instead
        .simultaneousGesture(
            MagnifyGesture()
                .onChanged { value in mosaic.zoom(to: baseline * value.magnification) }
                .onEnded { _ in baseline = mosaic.scale }
        )
        // show the current scale in a corner, above the tiles
        .overlay(alignment: .topTrailing) {
            Text("×\(mosaic.scale, format: .number.precision(.fractionLength(2)))")
                .monospacedDigit()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.thinMaterial, in: Capsule())
                .padding()
        }
    }
}


// end of file
