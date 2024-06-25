//
//  HapticFeedbackProvidable.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

public enum HapticFeedbackStyle {
    public enum ImpactStyle: CaseIterable {
        /// A collision between small, light user interface elements
        case light
        /// A collision between moderately sized user interface elements
        case medium
        /// A collision between large, heavy user interface elements
        case heavy
        /// A collision between user interface elements that are rigid,
        /// exhibiting a small amount of compression or elasticity
        case rigid
        /// A collision between user interface elements that are soft,
        /// exhibiting a large amount of compression or elasticity
        case soft
    }
    public enum NotifyStyle: CaseIterable {
        /// Indicates a task has been completed successfully
        case success
        /// Indicates a task has produced a warning
        case warning
        /// Indicates a task has failed
        case error
    }
    
    /// A collision between two elements
    case impact(ImpactStyle)
    /// Indicates a task has been completed
    case notify(NotifyStyle)
    /// Gives feedback when a user interface element is selected
    /// (not on initial selection)
    case selection
}

public protocol HapticFeedbackProvidable {
    func provideHapticFeedback(_ style: HapticFeedbackStyle)
}

extension HapticFeedbackProvidable {
    /// Provides the specified haptic feedback on the user's device
    ///
    /// - Parameters:
    ///   - style: The purpose and/or intensity of the haptic feedback
    public func provideHapticFeedback(_ style: HapticFeedbackStyle) {
        switch style {
        case .impact(let impact):
            switch impact {
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case .heavy:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            case .rigid:
                let generator = UIImpactFeedbackGenerator(style: .rigid)
                generator.impactOccurred()
            case .soft:
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
        case .notify(let notify):
            switch notify {
            case .success:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .warning:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            case .error:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
