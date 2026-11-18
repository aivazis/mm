// -*- swift -*-
// -*- coding: utf-8 -*-
//
// michael a.g. aïvázis <michael.aivazis@para-sim.com>
// (c) 1998-2026 all rights reserved


// support
import SwiftUI


/// The appearance the window asks for: the one the system chooses, or light or dark regardless
enum Appearance: CaseIterable, Identifiable {
    case system
    case light
    case dark

    // each case is its own identity
    var id: Self { self }

    // the word that names it on the screen
    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }

    // the color scheme it imposes; the system's choice imposes none
    var scheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}


// end of file
