//
//  Theme+Colors.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension Theme {
    public struct Colors {
        public let accent: UIColor
        public let secondary: UIColor
        
        public let background: UIColor
        public let secondaryBackground: UIColor
        
        public let label: UIColor
        public let secondaryLabel: UIColor
        public let tertiaryLabel: UIColor
        public let labelOnSecondary: UIColor
        
        public let error: UIColor
        public let success: UIColor
        public let info: UIColor
        public let warning: UIColor
        
        public let badge: UIColor
        public let buttonForeground: UIColor
        public let textFieldBorder: UIColor
        
        public let cardBackground: UIColor
        public let cardShadow: UIColor
        
        public let separator: UIColor
        
        public init(
            accent: UIColor = .systemBlue,
            secondary: UIColor = .systemPurple,
            background: UIColor = .systemBackground,
            secondaryBackground: UIColor = .secondarySystemBackground,
            label: UIColor = .label,
            secondaryLabel: UIColor = .secondaryLabel,
            tertiaryLabel: UIColor = .tertiaryLabel,
            labelOnSecondary: UIColor = .white,
            error: UIColor = .systemRed,
            success: UIColor = .systemGreen,
            info: UIColor = .systemTeal,
            warning: UIColor = .systemOrange,
            badge: UIColor = .systemRed,
            buttonForeground: UIColor = .white,
            textFieldBorder: UIColor = .opaqueSeparator,
            cardBackground: UIColor = .systemBackground,
            cardShadow: UIColor = .black.withAlphaComponent(0.15),
            separator: UIColor = .separator
        ) {
            self.accent = accent
            self.secondary = secondary
            
            self.background = background
            self.secondaryBackground = secondaryBackground
            
            self.label = label
            self.secondaryLabel = secondaryLabel
            self.tertiaryLabel = tertiaryLabel
            self.labelOnSecondary = labelOnSecondary
            
            self.error = error
            self.success = success
            self.info = info
            self.warning = warning
            
            self.badge = badge
            self.buttonForeground = buttonForeground
            self.textFieldBorder = textFieldBorder
            
            self.cardBackground = cardBackground
            self.cardShadow = cardShadow
            
            self.separator = separator
        }
        
        public func allColors() -> [UIColor] {
            [
                self.accent,
                self.secondary,
                
                self.background,
                self.secondaryBackground,
                
                self.label,
                self.secondaryLabel,
                self.tertiaryLabel,
                self.labelOnSecondary,
                
                self.error,
                self.success,
                self.info,
                self.warning,
                
                self.badge,
                self.buttonForeground,
                self.textFieldBorder,
                
                self.cardBackground,
                self.cardShadow,
                
                self.separator,
            ]
        }
    }
}
