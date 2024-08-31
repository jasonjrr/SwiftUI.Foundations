//
//  CardView.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

public struct CardViewShadow {
    public let color: Color?
    public let radius: CGFloat
    public let xOffset: CGFloat
    public let yOffset: CGFloat
    
    public init(color: Color? = nil, radius: CGFloat, xOffset: CGFloat = 0.0, yOffset: CGFloat = 0.0) {
        self.color = color
        self.radius = radius
        self.xOffset = xOffset
        self.yOffset = yOffset
    }
    
    public static func color(_ color: Color, radius: CGFloat, xOffset: CGFloat = 0.0, yOffset: CGFloat = 0.0) -> CardViewShadow {
        CardViewShadow(color: color, radius: radius, xOffset: xOffset, yOffset: yOffset)
    }
    
    public static func radius(_ radius: CGFloat, xOffset: CGFloat = 0.0, yOffset: CGFloat = 0.0) -> CardViewShadow {
        CardViewShadow(radius: radius, xOffset: xOffset, yOffset: yOffset)
    }
}

/// Creates a card around the `Content`
public struct CardView<Content>: View where Content: View {
    @ScaledMetric private var defaultPadding: CGFloat = 16.0
    @EnvironmentObject var theme: Theme
    private let cornerRadius: CGFloat
    private let borderWidth: CGFloat
    private let padding: EdgeInsets?
    private let shadow: CardViewShadow?
    @ViewBuilder private let content: () -> Content
    
    /// Initializes a new ``CardView``
    ///
    /// - Parameters:
    ///   - cornerRadius: The radius of the rounded corners
    ///   - borderWidth: The width of the border around the card
    ///   - padding: ``EdgeInsets`` the determine the padding of the `content`
    ///   - content: `ViewBuilder` for the content within the card
    public init(cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.5, padding: EdgeInsets? = nil, shadow: CardViewShadow? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.padding = padding
        self.shadow = shadow
        self.content = content
    }
    
    public var body: some View {
        self.content()
            .padding(self.padding ?? EdgeInsets(top: self.defaultPadding, leading: self.defaultPadding, bottom: self.defaultPadding, trailing: self.defaultPadding))
            .background {
                ZStack {
                    makeBackground()
                    if self.borderWidth > 0.0 {
                        RoundedRectangle(cornerRadius: self.cornerRadius)
                            .stroke(self.theme.colors.separator.color, lineWidth: self.borderWidth)
                            .padding(self.borderWidth / 2.0)
                    }
                }
            }
    }
    
    @ViewBuilder
    private func makeBackground() -> some View {
        if let shadow {
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .fill(self.theme.colors.cardBackground.color)
                .shadow(
                    color: shadow.color ?? self.theme.colors.cardShadow.color,
                    radius: shadow.radius,
                    x: shadow.xOffset,
                    y: shadow.yOffset)
        } else {
            RoundedRectangle(cornerRadius: self.cornerRadius)
                .fill(self.theme.colors.cardBackground.color)
        }
    }
}

extension View {
    /// Wraps the parent `View` in a card with a border
    ///
    /// - Parameters:
    ///   - cornerRadius: The radius of the rounded corners
    ///   - borderWidth: The width of the border around the card
    ///   - padding: ``EdgeInsets`` the determine the padding of the parent `View`
    ///   - shadow: ``CardViewShadow`` to configure the size, color, and position of the card's shadow, if any
    public func card(cornerRadius: CGFloat = 8.0, borderWidth: CGFloat = 1.5, padding: EdgeInsets? = nil, shadow: CardViewShadow? = nil) -> some View {
        CardView(cornerRadius: cornerRadius, borderWidth: borderWidth, padding: padding, shadow: shadow) {
            self
        }
    }
}

#if DEBUG
// MARK: Previews
struct CardView_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    static var previews: some View {
        Group {
            Button {
                // NO-OP
            } label: {
                Label("Why hello there!", systemImage: "person")
            }
            .card()
        }
        .environmentObject(theme)
    }
}
#endif
