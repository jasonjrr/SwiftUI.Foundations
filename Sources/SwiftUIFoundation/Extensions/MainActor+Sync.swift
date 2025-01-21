//
//  MainActor+Sync.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/20/25.
//

import Foundation

extension MainActor {
    public static func sync<Output>(work: @MainActor () -> Output) -> Output {
        if Thread.isMainThread {
            return MainActor.assumeIsolated { work() }
        }
        return DispatchQueue.main.sync {
            MainActor.assumeIsolated { work() }
        }
    }
}
