//
//  RadioButtonGroup.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// A group of redio-style buttons
///
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
///
/// - **Accessibility**:
///   - This view is labeled as a "Radio Button Group"
///   - Accessibility labels for `ItemContent` aggregated to this view
///   - Selection state for the `Item` is indicated through accessibility traits on the individual ``RadioButton``s
public struct RadioButtonGroup<Item, ItemContent>: View where Item: Identifiable & Equatable, ItemContent: View {
    @Environment(\.isEnabled) var isEnabled
    @EnvironmentObject var theme: Theme
    
    private let title: String?
    private let items: [Item]
    @Binding var selectedItem: Item?
    @ViewBuilder private let itemContent: (Item) -> ItemContent
    
    private var disabledColor: Color { self.theme.colors.disabledBackgroundColor.color }
    private var titleTextColor: Color { self.theme.colors.secondaryLabel.color }
    private var textColor: Color { self.theme.colors.label.color }
    
    /// Initializes a new `RadioButtonGroup`
    ///
    /// - Parameters:
    ///   - title: Optional title for the group
    ///   - items: Generic arract of type `Item` that represent the individual radio buttons in the group
    ///   - selectedItem: `Binding` for the select `Item` from `items`
    ///   - itemContent: `ViewBuilder` that creates the view for each `Item` in the group
    public init(
        title: String? = nil,
        items: [Item],
        selectedItem: Binding<Item?>,
        @ViewBuilder itemContent: @escaping (Item) -> ItemContent
    ) {
        self.title = title
        self.items = items
        self._selectedItem = selectedItem
        self.itemContent = itemContent
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if let title {
                Text(title)
                    .font(forStyle: .callout, weight: .medium)
                    .foregroundColor(self.titleTextColor)
            }
            ForEach(self.items) { item in
                RadioButton(item: item, selectedItem: self.$selectedItem, alignment: .top) {
                    self.itemContent(item)
                        .font(forStyle: .body)
                }
            }
        }
        .foregroundColor(self.isEnabled ? self.textColor : self.disabledColor)
        .accessibilityLabel(L10n.Accessibility.Buttons.radioButtonGroup)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
// MARK: Previews
struct RadioButtonGroup_Previews: PreviewProvider {
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
    static var previews: some View {
        Group {
            RadioButtonGroup(
                title: "Button Group",
                items: [
                    PreviewItem(id: 0, text: "Male"),
                    PreviewItem(id: 1, text: "Female"),
                    PreviewItem(id: 2, text: "Other"),
                ],
                selectedItem: .constant(PreviewItem(id: 0, text: "Male"))) {
                    Text($0.text)
                }
        }
        .environmentObject(theme)
        
        Group {
            RadioButtonGroup(
                title: "Button Group",
                items: [
                    PreviewItem(id: 0, text: "Male"),
                    PreviewItem(id: 1, text: "Female"),
                    PreviewItem(id: 2, text: "Other"),
                ],
                selectedItem: .constant(PreviewItem(id: 0, text: "Male"))) {
                    Text($0.text)
                }
            .disabled(true)
        }
        .previewDisplayName("Disabled")
        .environmentObject(theme)
    }
}
#endif
