//
//  KeyboardVisibilityNotifiable.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI
import Combine

public protocol KeyboardVisibilityNotifiable {
    var keyboardVisible: AnyPublisher<Bool, Never> { get }
}

extension KeyboardVisibilityNotifiable {
    public var keyboardVisible: AnyPublisher<Bool, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .map { _ in true },

            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in false }
        )
        .eraseToAnyPublisher()
    }
}
