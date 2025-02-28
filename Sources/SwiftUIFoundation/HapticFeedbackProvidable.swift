//
//  HapticFeedbackProvidable.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 2/28/25.
//

import UIKit

public enum HapticFeedbackStyle: CaseIterable {
    /// A collision between small, light user interface elements
    case impactLight
    /// A collision between moderately sized user interface elements
    case impactMedium
    /// A collision between large, heavy user interface elements
    case impactHeavy
    /// A collision between user interface elements that are rigid,
    /// exhibiting a small amount of compression or elasticity
    case impactRigid
    /// A collision between user interface elements that are soft,
    /// exhibiting a large amount of compression or elasticity
    case impactSoft
    /// Gives feedback when a user interface element is selected
    /// (not on initial selection)
    case selection
    /// Indicates a task has been completed successfully
    case notifySuccess
    /// Indicates a task has produced a warning
    case notifyWarning
    /// Indicates a task has failed
    case notifyError
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
        case .impactLight:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .impactMedium:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case .impactHeavy:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        case .impactRigid:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            generator.impactOccurred()
        case .impactSoft:
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        case .notifySuccess:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .notifyWarning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .notifyError:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}
