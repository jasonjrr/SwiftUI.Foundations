//
//  Theme.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI
import Combine

public class Theme: ObservableObject {
    @Published public var colors: Theme.Colors
    @Published public var fonts: Theme.Fonts
    
    @Published public var constants: Constants = Constants()
    public let timers: Timers = Timers()
    
    public init(
        colors: Theme.Colors = Colors(),
        fonts: Theme.Fonts = Fonts(),
        constants: Constants = Constants()
    ) {
        self.colors = colors
        self.fonts = fonts
        self.constants = constants
    }
}

// MARK: Constants
extension Theme {
    public struct Constants {
        public let disabledOpacity: Double
        
        public let minimumButtonSize: Double
        public let recommendedButtonSize: Double
        
        public let animationShortDistance: Double
        public let animationProgressSpinnerRevolution: Double
        
        public init(
            disabledOpacity: Double = 0.3,
            minimumButtonSize: Double = 44.0,
            recommendedButtonSize: Double = 48.0,
            animationShortDistance: Double = 0.18,
            animationProgressSpinnerRevolution: Double = 1.75
        ) {
            self.disabledOpacity = disabledOpacity
            self.minimumButtonSize = minimumButtonSize
            self.recommendedButtonSize = recommendedButtonSize
            self.animationShortDistance = animationShortDistance
            self.animationProgressSpinnerRevolution = animationProgressSpinnerRevolution
        }
    }
}

// MARK: Timers
extension Theme {
    public class Timers {
        public let timer1FPS: Publishers.Autoconnect<Timer.TimerPublisher> = Timer
            .publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
        public let timer30FPS: Publishers.Autoconnect<Timer.TimerPublisher> = Timer
            .publish(every: 1.0 / 30.0, on: .main, in: .common)
            .autoconnect()
        public let timer60FPS: Publishers.Autoconnect<Timer.TimerPublisher> = Timer
            .publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
        
        internal init() {}
    }
}
