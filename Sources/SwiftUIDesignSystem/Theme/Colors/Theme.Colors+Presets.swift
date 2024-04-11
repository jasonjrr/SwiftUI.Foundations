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
            accentColor: UIColor(hex: "#003C71")!,
            secondaryColor: UIColor(hex: "#61B5FF")!,
            background: .white,
            secondaryBackground: UIColor(hex: "#E0E0E0")!,
            label: UIColor(hex: "#505358")!,
            secondaryLabel: UIColor(hex: "#757575")!,
            tertiaryLabel: UIColor(hex: "#757575")!,
            labelOnSecondaryColor: .white,
            errorColor: .systemRed,
            successColor: .systemGreen,
            infoColor: .systemTeal,
            warningColor: .systemOrange,
            badgeColor: .systemRed,
            buttonForegroundColor: .white,
            textFieldBorderColor: UIColor(hex: "#E0E0E0")!,
            cardBackgroundColor: .white,
            cardShadowColor: .black.withAlphaComponent(0.15),
            disabledBackgroundColor: UIColor(hex: "#003C71")!.withAlphaComponent(0.3),
            disabledForegroundColor: .white,
            separatorColor: UIColor(hex: "#E0E0E0")!)
    }
}

