//
//  DisableAnimationsOnFirstLoadViewModifier.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/20/25.
//

import SwiftUI

public struct DisableAnimationsOnFirstLoadViewModifier: ViewModifier {
    @State private var isFirstLoad = true
    
    @usableFromInline
    init() {}
    
    public func body(content: Content) -> some View {
        content
            .transaction {
                guard self.isFirstLoad else { return }
                $0.animation = nil
                Task {
                    await MainActor.run {
                        self.isFirstLoad = false
                    }
                }
            }
    }
}

extension View {
    @inlinable
    public func disableAnimationsOnFirstLoad() -> some View {
        self.modifier(DisableAnimationsOnFirstLoadViewModifier())
    }
}
