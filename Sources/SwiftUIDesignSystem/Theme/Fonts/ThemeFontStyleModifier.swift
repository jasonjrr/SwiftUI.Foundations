//
//  ThemeFontStyleModifier.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Internal ``ViewModifier`` to support `.font(forStyle:)`
struct ThemeFontStyleModifier: ViewModifier {
    @EnvironmentObject var theme: Theme
    let style: Theme.Fonts.Style
    let weight: Font.Weight?
    let isItalic: Bool
    let design: Font.Design
   
    /// Initializes a new ``ThemeFontStyleModifier``
    ///
    /// - Parameters:
    ///   - style: The semantically named style of the font
    ///   - weight: The weight of the font. A `nil` weight is the same as `.regular`.
    ///   - isItalic: When `true` the font is in italics, if possible
    ///   - design: Only supported by the default system font unless used in a custom ``FontNameConfiguration``
    init(style: Theme.Fonts.Style, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) {
        self.style = style
        self.weight = weight
        self.isItalic = isItalic
        self.design = design
    }
    
    func body(content: Content) -> some View {
        content
            .font(self.theme.fonts.font(forStyle: self.style, weight: self.weight, isItalic: self.isItalic, design: self.design))
    }
}

extension View {
    /// Sets the default font for text in this view based on the ``Theme``.
    ///
    /// Use `font(forStyle:)` to apply a semantically styled font to all of the text in a view.
    ///
    /// - Parameters:
    ///   - style: The semantically named style of the font
    ///   - weight: The ``Font.Weight`` of the font
    ///   - isItalic: When `true` the font is in italics, if possible
    ///   - design: Only supported by the default system font unless used in a custom ``FontNameConfiguration``
    ///
    /// - Returns: A view with the default font set based on the values you supply.
    public func font(forStyle style: Theme.Fonts.Style, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) -> some View {
        self.modifier(ThemeFontStyleModifier(style: style, weight: weight, isItalic: isItalic, design: design))
    }
}
