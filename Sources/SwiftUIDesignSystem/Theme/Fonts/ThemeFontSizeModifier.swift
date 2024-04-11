//
//  ThemeFontSizeModifier.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Internal ``ViewModifier`` to support `.font(ofSize:)`
///
/// - Parameters:
///   - size: The point size of the font
///   - weight: The weight of the font. A `nil` weight is the same as `.regular`.
///   - isItalic: When `true` the font is displayed in *italics* if possible
///   - design: Supported by system fonts only
struct ThemeFontSizeModifier: ViewModifier {
    @EnvironmentObject var theme: Theme
    let size: CGFloat
    let weight: Font.Weight?
    let isItalic: Bool
    let design: Font.Design
    
    init(size: CGFloat, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) {
        self.size = size
        self.weight = weight
        self.isItalic = isItalic
        self.design = design
    }
    
    func body(content: Content) -> some View {
        content
            .font(self.theme.fonts.font(ofSize: self.size, weight: self.weight, isItalic: self.isItalic, design: self.design))
    }
}

extension View {
    /// Sets the default font for text in this view based on the ``Theme``.
    ///
    /// Use `font(ofSize:)` to apply a specific sized font to all of the text in a view.
    ///
    /// - Parameters:
    ///   - size: The size of the font that **does not** scale with the user's accessability settings
    ///   - weight: The ``Font.Weight`` of the font
    ///   - isItalic: When `true` it creates an italicized font when pissible
    ///   - design: Only supported by the default system font
    ///
    /// - Returns: A view with the default font set based on the values you supply.
    public func font(ofSize size: CGFloat, weight: Font.Weight? = nil, isItalic: Bool = false, design: Font.Design = .default) -> some View {
        self.modifier(ThemeFontSizeModifier(size: size, weight: weight, isItalic: isItalic, design: design))
    }
}
