// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import SwiftUI


/// Show every swatch of the catalog in a grid, in the appearance the viewer picks
struct SwatchesView: View {
    // the appearance the viewer asked for
    @State private var appearance = Appearance.system

    // as many columns as fit, none narrower than a swatch should be
    private let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]

    // the contents
    var body: some View {
        NavigationStack {
            // the swatches, in a grid that scrolls
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Swatch.all) { swatch in
                        // each one is a patch of its color over its name; the catalog picks the
                        // variant that matches the appearance
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(swatch.name))
                                .frame(height: 140)
                            Text(swatch.name)
                                .font(.headline)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Swatches")
            // the choice of appearance, in the toolbar; it takes the accent color of the catalog
            .toolbar {
                Picker("Appearance", selection: $appearance) {
                    ForEach(Appearance.allCases) { choice in
                        Text(choice.label).tag(choice)
                    }
                }
                .pickerStyle(.segmented)
            }
        }
        // impose the chosen appearance on the whole window
        .preferredColorScheme(appearance.scheme)
    }
}


// end of file
