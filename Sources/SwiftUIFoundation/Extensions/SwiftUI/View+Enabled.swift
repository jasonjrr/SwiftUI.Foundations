//
//  View+Enabled.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension View {
    /// Adds a condition that controls whether users can interact with this
    /// view.
    ///
    /// The higher views in a view hierarchy can override the value you set on
    /// this view. In the following example, the button isn't interactive
    /// because the outer `enabled(_:)` modifier overrides the inner one:
    ///
    ///     HStack {
    ///         Button(Text("Press")) {}
    ///         .enabled(true)
    ///     }
    ///     .enabled(false)
    ///
    /// - Parameter enabled: A Boolean value that determines whether users can
    ///   interact with this view.
    ///
    /// - Returns: A view that controls whether users can interact with this
    ///   view.
    @inlinable public func enabled(_ enabled: Bool) -> some View {
        self.disabled(!enabled)
    }
}
