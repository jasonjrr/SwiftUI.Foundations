//
//  ViewModel.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation

public typealias ViewModelDefinition = ObservableObject & Identifiable & Hashable

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
    
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    ///
    /// Implement this method to conform to the `Hashable` protocol. The
    /// components used for hashing must be the same as the components compared
    /// in your type's `==` operator implementation. Call `hasher.combine(_:)`
    /// with each of these components.
    ///
    /// - Important: In your implementation of `hash(into:)`,
    ///   don't call `finalize()` on the `hasher` instance provided,
    ///   or replace it with a different instance.
    ///   Doing so may become a compile-time error in the future.
    ///
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
      hasher.combine(self.id)
    }
}
