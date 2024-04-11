//
//  ShakeEffect.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

public struct ShakeEffect: GeometryEffect {
    private let amount: CGFloat = 10.0
    private let shakesPerUnit: CGFloat = 3.0
    public var animatableData: CGFloat

    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: self.amount * sin(self.animatableData * .pi * self.shakesPerUnit),
                y: 0.0
            )
        )
    }
}
