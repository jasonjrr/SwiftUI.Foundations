//
//  RadioButton.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI
import Combine

/// Creates a radio button that has mutally exclusive selection
///
/// - **Accessibility**:
///   - Accessibility labels for `Content` aggregated to this view
///   - Selection state for the `Item` is indicated through accessibility traits
public struct RadioButton<Item, Content>: View where Item: Identifiable, Content: View {
    public enum RadioPosition {
        case leading
        case trailing
    }
    public struct CardWrapper {
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
        let padding: EdgeInsets?
        let shadow: CardViewShadow?
        
        public init(
            cornerRadius: CGFloat = 8.0,
            borderWidth: CGFloat = 1.5,
            padding: EdgeInsets? = nil,
            shadow: CardViewShadow? = nil
        ) {
            self.cornerRadius = cornerRadius
            self.borderWidth = borderWidth
            self.padding = padding
            self.shadow = shadow
        }
        
        public static func card(
            cornerRadius: CGFloat = 8.0,
            borderWidth: CGFloat = 1.5,
            padding: EdgeInsets? = nil,
            shadow: CardViewShadow? = nil
        ) -> Self {
            .init(
                cornerRadius: cornerRadius,
                borderWidth: borderWidth,
                padding: padding,
                shadow: shadow)
        }
        
        public static var card: Self {
            .init()
        }
    }
    
    @Environment(\.isEnabled) var isEnabled
    @EnvironmentObject var theme: Theme
    
    @ScaledMetric private var radioOuterCircleSize: CGFloat = 16.0
    @ScaledMetric private var radioOuterCircleStroke: CGFloat = 2.0
    @ScaledMetric private var radioInnerCircleSize: CGFloat = 8.0
    @ScaledMetric private var radioTopPadding: CGFloat = 1.0
    
    private var selectedColor: Color { self.theme.colors.accent.color }
    private var unselectedColor: Color { self.theme.colors.secondaryLabel.color }
    
    private let item: Item
    @Binding private var selectedItem: Item?
    private let position: Self.RadioPosition
    private let cardWrapper: Self.CardWrapper?
    private let alignment: VerticalAlignment
    @ViewBuilder private let content: () -> Content
    
    private var isSelected: Bool {
        self.item.id == self.selectedItem?.id
    }
    
    /// Initializes a new ``RadioButton``
    ///
    /// - Parameters:
    ///   - item: The `Item` represented by this radio button
    ///   - selectedItem: The `Item` that is selected which may not be the `Item` represented by this radio button
    ///   - position: The horizontal position of the radio knob
    ///   - cardWrapper: Configures wrapping the radio button in a default styled card. When this is `nil` there is no card wrapper.
    ///   - alignment: The guide for aligning the radio knob with the `Content`
    ///   - content: The ``View`` displayed besides the radio knob
    public init(
        item: Item,
        selectedItem: Binding<Item?>,
        position: Self.RadioPosition = .leading,
        cardWrapper: Self.CardWrapper? = nil,
        alignment: VerticalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.item = item
        self._selectedItem = selectedItem
        self.position = position
        self.cardWrapper = cardWrapper
        self.alignment = alignment
        self.content = content
    }
    
    public var body: some View {
        Button {
            self.selectedItem = self.item
        } label: {
            if let cardWrapper {
                makeBody().card(
                    cornerRadius: cardWrapper.cornerRadius,
                    borderWidth: cardWrapper.borderWidth,
                    padding: cardWrapper.padding,
                    shadow: cardWrapper.shadow)
            } else {
                makeBody()
            }
        }
        .opacity(self.isEnabled ? 1.0 : self.theme.constants.disabledOpacity)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(
            self.isSelected
            ? [.isSelected, .isButton]
            : [.isButton]
        )
    }
    
    @ViewBuilder
    private func makeBody() -> some View {
        HStack(alignment: self.alignment) {
            if self.position == .leading {
                radioKnob()
            }
            self.content()
                .multilineTextAlignment(.leading)
            if self.position == .trailing {
                Spacer()
                radioKnob()
            }
        }
    }
    
    private func radioKnob() -> some View {
        ZStack {
            Circle()
                .stroke(
                    getRadioColor(),
                    lineWidth: self.radioOuterCircleStroke)
                .frame(width: self.radioOuterCircleSize, height: self.radioOuterCircleSize)
            if self.isSelected {
                Circle()
                    .fill(self.selectedColor)
                    .frame(width: self.radioInnerCircleSize, height: self.radioInnerCircleSize)
                    .transition(.scale)
                    .animation(.easeOut, value: self.isSelected)
            }
        }
        .padding(self.radioOuterCircleStroke / 2.0)
        .padding(.top, self.radioTopPadding)
    }
    
    private func getRadioColor() -> Color {
        return self.isSelected
        ? self.selectedColor
        : self.unselectedColor
    }
}

#if DEBUG
// MARK: Previews
struct RadioButton_Previews: PreviewProvider {
    struct PreviewItem: Identifiable, Equatable {
        let id: Int
        let text: String
        
        // swiftlint:disable operator_whitespace
        static func ==(lhs: PreviewItem, rhs: PreviewItem) -> Bool {
            lhs.id == rhs.id
            && lhs.text == rhs.text
        }
        // swiftlint:enable operator_whitespace
    }
    
    static let theme: Theme = Theme()
    static let items: [PreviewItem] = [
        PreviewItem(id: 0, text: "Item 1"),
        PreviewItem(id: 1, text: "Item 2"),
    ]
    static let selectedItem: Binding<PreviewItem?> = .constant(Self.items.first)
    static var previews: some View {
        Group {
            VStack(alignment: .leading) {
                ForEach(Self.items) { item in
                    RadioButton(item: item, selectedItem: Self.selectedItem) {
                        Text(item.text)
                            .font(forStyle: .body)
                            .foregroundColor(self.theme.colors.label.color)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .environmentObject(self.theme)
    }
}
#endif
