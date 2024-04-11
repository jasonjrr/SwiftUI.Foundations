//
//  UIColor+Color.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension UIColor {
    /// - Returns: a ``Color`` View from this `UIColor`
    @inlinable
    public var color: Color { Color(uiColor: self) }
}
