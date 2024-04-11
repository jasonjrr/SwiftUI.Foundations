//
//  Theme.Fonts+SupportedFonts.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

extension Theme.Fonts {
    /// Creates a ``Theme.Fonts`` for the default system font
    public static var systemFonts: Theme.Fonts {
        Theme.Fonts()
    }
    
    /// Creates a ``Theme.Fonts`` for the "Avenir Next" font
    public static var avenirNextFonts: Theme.Fonts {
        Theme.Fonts(
            fontName: "Avenir Next",
            configuration: FontNameConfiguration(
                black: "Avenir Next Heavy",
                heavy: "Avenir Next Heavy",
                bold: "Avenir Next Bold",
                semibold: "Avenir Next Demi Bold",
                medium: "Avenir Next Medium",
                regular: "Avenir Next",
                light: "Avenir Next Light",
                thin: "Avenir Next Light",
                ultraLight: "Avenir Next Ultra Light",
                italic: "Italic"))
    }
    
    /// Creates a ``Theme.Fonts`` for the "Helvetica Neue" font
    public static var helveticaNeue: Theme.Fonts {
        Theme.Fonts(
            fontName: "Helvetica Neue",
            configuration: FontNameConfiguration(
                black: "Helvetica Neue Bold",
                heavy: "Helvetica Neue Bold",
                bold: "Helvetica Neue Bold",
                semibold: "Helvetica Neue Medium",
                medium: "Helvetica Neue Medium",
                regular: "Helvetica Neue",
                light: "Helvetica Neue Light",
                thin: "Helvetica Neue Thin",
                ultraLight: "Helvetica Neue UltraLight",
                italic: "Italic"))
    }
    
    /// Creates a ``Theme.Fonts`` for the "Impact" font
    public static var impact: Theme.Fonts {
        Theme.Fonts(fontName: "Impact")
    }
}
