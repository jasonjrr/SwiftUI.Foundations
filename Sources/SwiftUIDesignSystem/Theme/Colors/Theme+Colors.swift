//
//  Theme+Colors.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension Theme {
    public struct Colors {
        public let accentColor: UIColor
        public let secondaryColor: UIColor
        
        public let background: UIColor
        public let secondaryBackground: UIColor
        
        public let label: UIColor
        public let secondaryLabel: UIColor
        public let tertiaryLabel: UIColor
        public let labelOnSecondaryColor: UIColor
        
        public let errorColor: UIColor
        public let successColor: UIColor
        public let infoColor: UIColor
        public let warningColor: UIColor
        
        public let badgeColor: UIColor
        public let buttonForegroundColor: UIColor
        public let textFieldBorderColor: UIColor
        
        public let cardBackgroundColor: UIColor
        public let cardShadowColor: UIColor
        
        public let disabledBackgroundColor: UIColor
        public let disabledForegroundColor: UIColor
        
        public let separatorColor: UIColor
        
        public init(
            accentColor: UIColor = .systemBlue,
            secondaryColor: UIColor = .systemPurple,
            background: UIColor = .systemBackground,
            secondaryBackground: UIColor = .secondarySystemBackground,
            label: UIColor = .label,
            secondaryLabel: UIColor = .secondaryLabel,
            tertiaryLabel: UIColor = .tertiaryLabel,
            labelOnSecondaryColor: UIColor = .white,
            errorColor: UIColor = .systemRed,
            successColor: UIColor = .systemGreen,
            infoColor: UIColor = .systemTeal,
            warningColor: UIColor = .systemOrange,
            badgeColor: UIColor = .systemRed,
            buttonForegroundColor: UIColor = .white,
            textFieldBorderColor: UIColor = .opaqueSeparator,
            cardBackgroundColor: UIColor = .systemBackground,
            cardShadowColor: UIColor = .black.withAlphaComponent(0.15),
            disabledBackgroundColor: UIColor = .black.withAlphaComponent(0.275),
            disabledForegroundColor: UIColor = .black.withAlphaComponent(0.5),
            separatorColor: UIColor = .separator
        ) {
            self.accentColor = accentColor
            self.secondaryColor = secondaryColor
            
            self.background = background
            self.secondaryBackground = secondaryBackground
            
            self.label = label
            self.secondaryLabel = secondaryLabel
            self.tertiaryLabel = tertiaryLabel
            self.labelOnSecondaryColor = labelOnSecondaryColor
            
            self.errorColor = errorColor
            self.successColor = successColor
            self.infoColor = infoColor
            self.warningColor = warningColor
            
            self.badgeColor = badgeColor
            self.buttonForegroundColor = buttonForegroundColor
            self.textFieldBorderColor = textFieldBorderColor
            
            self.cardBackgroundColor = cardBackgroundColor
            self.cardShadowColor = cardShadowColor
            
            self.disabledBackgroundColor = disabledBackgroundColor
            self.disabledForegroundColor = disabledForegroundColor
            
            self.separatorColor = separatorColor
        }
        
        public func allColors() -> [UIColor] {
            [
                self.accentColor,
                self.secondaryColor,
                
                self.background,
                self.secondaryBackground,
                
                self.label,
                self.secondaryLabel,
                self.tertiaryLabel,
                self.labelOnSecondaryColor,
                
                self.errorColor,
                self.successColor,
                self.infoColor,
                self.warningColor,
                
                self.badgeColor,
                self.buttonForegroundColor,
                self.textFieldBorderColor,
                
                self.cardBackgroundColor,
                self.cardShadowColor,
                
                self.disabledBackgroundColor,
                self.disabledForegroundColor,
                
                self.separatorColor,
            ]
        }
    }
}
