//
//  Theme.Colors+Presets.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI
import SwiftUIFoundation

extension Theme.Colors {
    /// The default color palette. It supports both light and dark appearances.
    public static var `default`: Theme.Colors {
        Theme.Colors()
    }
    
    public static var sampleLightAppearance: Theme.Colors {
        Theme.Colors(
            accent: UIColor(hex: "#003C71")!,
            secondary: UIColor(hex: "#61B5FF")!,
            background: .white,
            secondaryBackground: UIColor(hex: "#E0E0E0")!,
            label: UIColor(hex: "#505358")!,
            secondaryLabel: UIColor(hex: "#757575")!,
            tertiaryLabel: UIColor(hex: "#757575")!,
            labelOnSecondary: .white,
            error: .systemRed,
            success: .systemGreen,
            info: .systemTeal,
            warning: .systemOrange,
            badge: .systemRed,
            buttonForeground: .white,
            textFieldBorder: UIColor(hex: "#E0E0E0")!,
            cardBackground: .white,
            cardShadow: .black.withAlphaComponent(0.15),
            separator: UIColor(hex: "#E0E0E0")!
        )
    }
}

