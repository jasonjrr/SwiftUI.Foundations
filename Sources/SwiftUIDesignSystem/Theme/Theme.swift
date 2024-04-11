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
        
        public let listItemCardCornerRadius: Double
        public let listItemSquareImageCornerRadius: Double
        
        public let questionFieldCardCornerRadius: Double
        public let questionFieldMinHeight: Double
        public let questionFieldShadowRadius: Double
        public let questionFieldShadowYOffset: Double
        
        public init(
            disabledOpacity: Double = 0.3,
            minimumButtonSize: Double = 44.0,
            recommendedButtonSize: Double = 48.0,
            animationShortDistance: Double = 0.18,
            animationProgressSpinnerRevolution: Double = 1.75,
            listItemCardCornerRadius: Double = 8.0,
            listItemSquareImageCornerRadius: Double = 4.0,
            questionFieldCardCornerRadius: Double = 16.0,
            questionFieldMinHeight: Double = 56.0,
            questionFieldShadowRadius: Double = 32.0,
            questionFieldShadowYOffset: Double = 4.0
        ) {
            self.disabledOpacity = disabledOpacity
            self.minimumButtonSize = minimumButtonSize
            self.recommendedButtonSize = recommendedButtonSize
            self.animationShortDistance = animationShortDistance
            self.animationProgressSpinnerRevolution = animationProgressSpinnerRevolution
            self.listItemCardCornerRadius = listItemCardCornerRadius
            self.listItemSquareImageCornerRadius = listItemSquareImageCornerRadius
            self.questionFieldCardCornerRadius = questionFieldCardCornerRadius
            self.questionFieldMinHeight = questionFieldMinHeight
            self.questionFieldShadowRadius = questionFieldShadowRadius
            self.questionFieldShadowYOffset = questionFieldShadowYOffset
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
