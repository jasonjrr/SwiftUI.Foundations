//
//  Theme.Fonts+FontNameConfiguration.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension Theme.Fonts {
    /// Configuration describing how to formate the font name for use within the app.
    public struct FontNameConfiguration {
        public let black: String
        public let heavy: String
        public let bold: String
        public let semibold: String
        public let medium: String
        public let regular: String
        public let light: String
        public let thin: String
        public let ultraLight: String
        public let italic: String
        private let nameFormatter: ((_ name: String, _ weight: Font.Weight, _ isItalic: Bool, _ design: Font.Design) -> String)?
        
        /// Initializes a new ``FontNameConfiguration``
        ///
        /// - Parameters:
        ///   - black: Font name for a "black" weight font
        ///   - heavy: Font name for a "heavy" weight font
        ///   - bold: Font name for a "bold" weight font
        ///   - semibold: Font name for a "semibold", or sometimes "demi bold", weight font
        ///   - medium: Font name for a "medium" weight font
        ///   - regular: Font name for a "regualr" weight font. This is the `default` font weight.
        ///   - light: Font name for a "light" weight font
        ///   - thin: Font name for a "thin" weight font
        ///   - ultraLight: Font name for an "ultra light" weight font
        ///   - italic: Name segment that indicates an italic font
        ///   - nameFormatter: Closure that allows you to customize how the font name is formatted.
        ///       The default font name formatter is
        ///       `"[weighted name]"
        ///       or `"[weighted name] [italic]"` for italic fonts
        public init(
            black: String,
            heavy: String,
            bold: String,
            semibold: String,
            medium: String,
            regular: String,
            light: String,
            thin: String,
            ultraLight: String,
            italic: String,
            nameFormatter: ((_ name: String, _ weight: Font.Weight, _ isItalic: Bool, _ design: Font.Design) -> String)? = nil
        ) {
            self.black = black
            self.heavy = heavy
            self.bold = bold
            self.semibold = semibold
            self.medium = medium
            self.regular = regular
            self.light = light
            self.thin = thin
            self.ultraLight = ultraLight
            self.italic = italic
            self.nameFormatter = nameFormatter
        }
        
        /// The name of the font for a given ``Weight``
        ///
        /// - Parameters:
        ///   - weight: The ``Weight`` of the desired font
        ///
        /// - Returns: A ``String`` for the desired font name
        public func name(forWeight weight: Font.Weight) -> String {
            switch weight {
            case .black: return self.black
            case .heavy: return self.heavy
            case .bold: return self.bold
            case .semibold: return self.semibold
            case .medium: return self.medium
            case .regular: return self.regular
            case .light: return self.light
            case .thin: return self.thin
            case .ultraLight: return self.ultraLight
            default: return self.regular
            }
        }
        
        /// The name of the font formatted for `weight`, `italics`, and `design`
        ///
        /// - Parameters:
        ///   - weight: The ``Weight`` of the desired font
        ///   - isItalic: When `true` appends the `italic` property to the font name
        ///   - design:Only supported by the default system font unless used in the `nameFormatter`
        public func formattedName(weight: Font.Weight = .regular, isItalic: Bool = false, design: Font.Design = .default) -> String {
            if let nameFormatter {
                return nameFormatter(name(forWeight: weight), weight, isItalic, design)
            } else {
                var formatted: String = name(forWeight: weight)
                if isItalic {
                    formatted = formatted + " \(self.italic)"
                }
                return formatted
            }
        }
    }
}
