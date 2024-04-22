//
//  L10n.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

enum L10n {
    static var bundle: Bundle { SwiftUIDesignSystemResources.resourceBundle }
}

protocol Localized {}
extension Localized {
    static var tableName: String { "Localizable" }
}
