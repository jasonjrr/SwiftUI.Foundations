//
//  PopEffect.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

public struct PopEffect: GeometryEffect {
    public var scale: CGFloat = 1.2
    public var animatableData: CGFloat
    
    public init(animatableData: CGFloat) {
        self.animatableData = animatableData
    }
    
    public func effectValue(size: CGSize) -> ProjectionTransform {
        let reducedValue = self.animatableData - floor(self.animatableData)
        let value = 1.0 - (cos(2.0 * reducedValue * Double.pi) + 1.0) / 2
        let scaleFactor = 1.0 + 0.2 * value
        
        print("reducedValue \(reducedValue); value \(value); scale \(scaleFactor)")
        
        return ProjectionTransform(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
    }
}
