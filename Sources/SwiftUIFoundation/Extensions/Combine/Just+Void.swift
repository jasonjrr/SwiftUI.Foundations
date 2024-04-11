//
//  Just+Void.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Combine

extension Just {
    /// Creates a ``Just`` `Publisher` with an Output type of `Void`
    public init() where Output == Void {
        self.init(())
    }
}
