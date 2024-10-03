//
//  Publisher+JustLatest.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Combine
import CombineExt

extension Publisher {
    /// Upon an emission from `self`, emit the latest value, if any exists,
    /// and complete.
    ///
    /// - returns: A publisher containing the latest value from `self`, if any.
    public func justLatest() -> Publishers.WithLatestFrom<Result<(), Failure>.Publisher, Self, Self.Output> {
        Just()
            .setFailureType(to: Failure.self)
            .withLatestFrom(self)
    }
}
