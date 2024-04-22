//
//  L10n+Accessibility.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension L10n {
    enum Accessibility {}
}

// MARK: Buttons
extension L10n.Accessibility {
    enum Buttons: Localized {
        static var buttonGroup: Text {
            Text("accessibility.button.group", tableName: tableName, bundle: L10n.bundle)
        }
        
        static var radioButtonGroup: Text {
            Text("accessibility.button.radio.button.group", tableName: tableName, bundle: L10n.bundle)
        }
    }
}

// MARK: Rating View
extension L10n.Accessibility {
    enum RatingView: Localized {
        static var label: Text {
            Text("accessibility.rating.view.label", tableName: tableName, bundle: L10n.bundle)
        }
        
        static func rating(value: Int) -> Text {
            Text("accessibility.rating.view.value.\(value)", tableName: tableName, bundle: L10n.bundle)
        }
    }
}
