//
//  UserDefaults+Key.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/28/25.
//

import Foundation

extension UserDefaults {
    public protocol Key: RawRepresentable<String>, Sendable {}
}
