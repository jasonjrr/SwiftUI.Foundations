//
//  Theme+Fonts.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension Theme {
    // Handles font configuration for your theme
    public struct Fonts {
        public let fontName: String
        public let configuration: FontNameConfiguration?
        
        /// Initializes a new ``Theme.Fonts`` object
        ///
        /// - Parameters:
        ///   - fontName: The name of the font. This can be any system supported font or any font included within the app
        ///   - configuration: Describes how to format the font name to be used within the system based on defined styles
        public init(
            fontName: String = "SF Pro",
            configuration: FontNameConfiguration? = nil
        ) {
            self.fontName = fontName
            self.configuration = configuration
        }
    }
}

extension Theme.Fonts {
    private static let systemFontName: String = "SF Pro"
 
    /// Symantically named font styles matching Apple's predefined styles
    public enum Style: String, CaseIterable {
        /// A font with the large title text style.
        case largeTitle = "large-title"
        /// A font with the title text style.
        case title = "title"
        /// A font for second level hierarchical headings.
        case title2 = "title2"
        /// A font for third level hierarchical headings.
        case title3 = "title3"
        /// A font with the headline text style.
        case headline = "headline"
        /// A font with the body text style.
        case body = "body"
        /// A font with the callout text style.
        case callout = "callout"
        /// A font with the subheadline text style.
        case subheadline = "subheadline"
        /// A font with the footnote text style.
        case footnote = "footnote"
        /// A font with the caption text style.
        case caption = "caption"
        /// A font with the alternate caption text style.
        case caption2 = "caption2"
    }
    
    /// Create a font based on a symantic ``Theme.Fonts.Style`` which scaled with the user's accessability settings
    ///
    /// - Parameters:
    ///   - style: The symantically named font style matching Apple's predefined styles
    ///   - weight: The weight or thickness of characters in the font
    ///   - isItalic: When `true`, creates an italisized font when possible
    ///   - design: Only supported by the default system font unless used in a custom ``FontNameConfiguration``
    public func font(forStyle style: Style, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) -> Font {
        if self.fontName == Self.systemFontName {
            var font: Font
            switch style {
            case .largeTitle: font = .system(.largeTitle, design: design)
            case .title: font = .system(.title, design: design)
            case .title2: font = .system(.title2, design: design)
            case .title3: font = .system(.title3, design: design)
            case .headline: font = .system(.headline, design: design)
            case .body: font = .system(.body, design: design)
            case .callout: font = .system(.callout, design: design)
            case .subheadline: font = .system(.subheadline, design: design)
            case .footnote: font = .system(.footnote, design: design)
            case .caption: font = .system(.caption, design: design)
            case .caption2: font = .system(.caption2, design: design)
            }
            if let weight {
                font = font.weight(weight)
            }
            if isItalic {
                font = font.italic()
            }
            return font
        } else {
            guard let configuration else {
                return .custom(self.fontName, size: 17.0, relativeTo: .body)
            }
            // Reference for font sizes used by iOS:
            // https://developer.apple.com/design/human-interface-guidelines/foundations/typography/#specifications
            switch style {
            case .largeTitle: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 34.0, relativeTo: .largeTitle)
            case .title: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 28.0, relativeTo: .title)
            case .title2: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 22.0, relativeTo: .title2)
            case .title3: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 20.0, relativeTo: .title3)
            case .headline: return .custom(configuration.formattedName(weight: weight ?? .semibold, isItalic: isItalic, design: design), size: 17.0, relativeTo: .headline)
            case .body: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 17.0, relativeTo: .body)
            case .callout: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 16.0, relativeTo: .callout)
            case .subheadline: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 15.0, relativeTo: .subheadline)
            case .footnote: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 13.0, relativeTo: .footnote)
            case .caption: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 12.0, relativeTo: .caption)
            case .caption2: return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: 11.0, relativeTo: .caption2)
            }
        }
    }
    
    /// Creates a font of the given size that **does not** scale with the user's accessibility settings
    ///
    /// - Parameters:
    ///   - size: The point size of the font
    ///   - weight: The weight or thickness of characters in the font
    ///   - isItalic: When `true`, creates an italisized font when possible
    ///   - design: Only supported by the default sytem font or when used within a custon font name formatter set in the ``FontNameConfiguration``
    ///
    /// - Returns: A ``Font`` based on the imput parameters that **does not** scale with the user's accessibiliy settings
    public func font(ofSize size: CGFloat, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) -> Font {
        if self.fontName == Self.systemFontName {
            return isItalic
            ? .system(size: size, design: design).weight(weight ?? .regular).italic()
            : .system(size: size, design: design).weight(weight ?? .regular)
        } else {
            guard let configuration else {
                return .custom(self.fontName, size: 17.0)
            }
            return .custom(configuration.formattedName(weight: weight ?? .regular, isItalic: isItalic, design: design), size: size)
        }
    }
}
