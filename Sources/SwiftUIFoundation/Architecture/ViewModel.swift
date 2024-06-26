//
//  ViewModel.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation

public typealias ViewModelDefinition = ObservableObject & Identifiable

/// Minimum definition of what is needed for a SwiftUI supported `ViewModel`.
/// We use the `protocol` instead of the `typealias`, because it can be extended.
public protocol ViewModel: ViewModelDefinition {}

extension ViewModel {
    /// Dispatches work to the **main** queue if we are not currently on the main thread
    ///
    /// - Parameters:
    ///   -  action: the closure that will be executed on the **main** thread/queue. `action` is marked with `@escaping`, but will not hold a reference.
    public func dispatchMainIfNecessary(_ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.async {
                action()
            }
        }
    }
}
