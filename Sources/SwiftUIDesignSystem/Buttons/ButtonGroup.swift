//
//  ButtonGroup.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Horizontal set of buttons where only one can be selected
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
///
/// - **Accessibility**:
///   - This view is labeled as a "Button Group"
///   - Accessibility labels for `ItemContent` aggregated to this view
///   - Selection state for each `Item` is indicated through accessibility traits
public struct ButtonGroup<Item, ItemContent>: View where Item: Identifiable, ItemContent: View {
    @EnvironmentObject var theme: Theme
    @ScaledMetric private var borderWidth: CGFloat = 1.0
    
    private let items: [Item]
    @Binding var selectedItem: Item?
    private let itemContent: (Item) -> ItemContent
    
    private var selectedForegroundColor: Color { self.theme.colors.buttonForegroundColor.color }
    
    /// Initializes a new `ButtonGroup`
    ///
    /// - Parameters:
    ///   - items: Generic array of `Item`s that represent the buttons
    ///   - selectedItem: The `Item` selected from `items`
    ///   - itemContent: Closure that creates the view for each `Item` in `items`. Accessibility for `Item`s must be handled by the developer.
    public init(
        items: [Item],
        selectedItem: Binding<Item?>,
        itemContent: @escaping (Item) -> ItemContent
    ) {
        self.items = items
        self._selectedItem = selectedItem
        self.itemContent = itemContent
    }
    
    public var body: some View {
        HStack(spacing: 0.0) {
            ForEach(self.items) { item in
                Button {
                    self.selectedItem = item
                } label: {
                    self.itemContent(item)
                        .font(forStyle: .headline)
                        .foregroundColor(
                            self.selectedItem?.id == item.id
                            ? self.selectedForegroundColor
                            : Color.accentColor
                        )
                        .padding()
                        .background(
                            self.selectedItem?.id == item.id
                            ? Color.accentColor
                            : Color.clear
                        )
                }
                .overlay {
                    Rectangle()
                        .stroke(Color.accentColor, lineWidth: self.borderWidth)
                }
                .accessibilityAddTraits(
                    self.selectedItem?.id == item.id
                    ? [.isSelected, .isButton]
                    : [.isButton]
                )
            }
        }
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.accentColor, lineWidth: self.borderWidth)
                .padding(self.borderWidth / 2.0)
        )
        .accentColor(self.theme.colors.accentColor.color)
        .accessibilityLabel(L10n.Accessibility.Buttons.buttonGroup)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
// MARK: Previews
struct ButtonGroup_Previews: PreviewProvider {
    struct PreviewItem: Identifiable {
        let id: Int
        let text: String
    }
    
    static let theme: Theme = Theme()
    static var previews: some View {
        Group {
            VStack {
                ButtonGroup(
                    items: [
                        PreviewItem(id: 0, text: "Button 1"),
                        PreviewItem(id: 1, text: "Button 2"),
                        PreviewItem(id: 2, text: "Button 3"),
                    ],
                    selectedItem: .constant(PreviewItem(id: 0, text: "Button 1"))) {
                        Text($0.text)
                    }
                
                ButtonGroup(
                    items: [
                        PreviewItem(id: 0, text: "Button 1"),
                        PreviewItem(id: 1, text: "Button 2"),
                        PreviewItem(id: 2, text: "Button 3"),
                    ],
                    selectedItem: .constant(PreviewItem(id: 1, text: "Button 2"))) {
                        Text($0.text)
                    }
                
                ButtonGroup(
                    items: [
                        PreviewItem(id: 0, text: "Button 1"),
                        PreviewItem(id: 1, text: "Button 2"),
                        PreviewItem(id: 2, text: "Button 3"),
                    ],
                    selectedItem: .constant(PreviewItem(id: 2, text: "Button 3"))) {
                        Text($0.text)
                    }
            }
        }
        .environmentObject(theme)
    }
}
#endif
