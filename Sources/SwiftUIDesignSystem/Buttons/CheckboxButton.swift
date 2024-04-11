//
//  CheckboxButton.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Standard checkbox view
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
///
/// - **Accessibility**:
///   - This view is labeled with the indicated `labelText`
///   - Selection state is indicated through accessibility traits
public struct CheckboxButton: View, HapticFeedbackProvidable {
    @Environment(\.isEnabled) var isEnabled
    @EnvironmentObject var theme: Theme
    
    @ScaledMetric private var checkboxSize: CGFloat = 24.0
    @ScaledMetric private var checkmarkPadding: CGFloat = 4.0
    
    @Binding private var isChecked: Bool
    private let labelText: String?
    
    private var checkmarkColor: Color { self.theme.colors.buttonForegroundColor.color }
    private var checkedBorderColor: Color {
        self.isEnabled
        ? self.theme.colors.accentColor.color
        : self.theme.colors.disabledBackgroundColor.color
    }
    private var uncheckedBorderColor: Color {
        self.isEnabled
        ? self.theme.colors.textFieldBorderColor.color
        : self.theme.colors.disabledBackgroundColor.color
    }
    private var labelTextColor: Color { self.theme.colors.label.color }
    
    private var disabledBorderColor: Color { self.theme.colors.disabledForegroundColor.color }
    
    /// Initializes a new `CheckboxButton`
    ///
    /// - Parameters:
    ///   - isChecked: The `Binding` value if the checkbox is checked or not
    ///   - labelText: Optional text for the button
    public init(isChecked: Binding<Bool>, labelText: String? = nil) {
        self._isChecked = isChecked
        self.labelText = labelText
    }
    
    public var body: some View {
        Button {
            self.isChecked.toggle()
            if self.isChecked {
                provideHapticFeedback(.selection)
            } else {
                provideHapticFeedback(.impact(.light))
            }
        } label: {
            HStack {
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: self.checkboxSize, height: self.checkboxSize)
                    .background {
                        if self.isChecked {
                            RoundedRectangle(cornerRadius: 4.0)
                                .fill(self.checkedBorderColor)
                        } else {
                            RoundedRectangle(cornerRadius: 4.0)
                                .strokeBorder(getBorderColor(), lineWidth: 2.0)
                        }
                    }
                    .overlay {
                        if self.isChecked {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(self.checkmarkColor)
                                .padding(self.checkmarkPadding)
                                .transition(.scale)
                                .animation(.easeInOut(duration: 0.18), value: self.isChecked)
                        }
                    }
                
                if let labelText, !labelText.isEmpty {
                    Text(labelText)
                        .font(forStyle: .headline)
                        .foregroundColor(self.isEnabled ? self.labelTextColor : self.disabledBorderColor)
                        .accessibilityLabel(labelText)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(
            self.isChecked
            ? [.isSelected, .isButton]
            : [.isButton]
        )
    }
    
    private func getBorderColor() -> Color {
        self.isChecked
        ? self.checkedBorderColor
        : self.uncheckedBorderColor
    }
}

#if DEBUG
// MARK: Previews
struct CheckboxButton_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    static var previews: some View {
        // MARK: Overview
        Group {
            VStack(alignment: .leading, spacing: 16.0) {
                CheckboxButton(isChecked: .constant(false))
                CheckboxButton(isChecked: .constant(true))
                
                CheckboxButton(isChecked: .constant(false), labelText: "Unchecked")
                CheckboxButton(isChecked: .constant(true), labelText: "Checked")
            }
            .padding()
        }
        .previewDisplayName("Overview")
        .environmentObject(theme)
        
        // MARK: Disabled
        Group {
            VStack(alignment: .leading, spacing: 16.0) {
                CheckboxButton(isChecked: .constant(false))
                CheckboxButton(isChecked: .constant(true))
                
                CheckboxButton(isChecked: .constant(false), labelText: "Unchecked")
                CheckboxButton(isChecked: .constant(true), labelText: "Checked")
            }
            .padding()
            .disabled(true)
        }
        .previewDisplayName("Disabled")
        .environmentObject(theme)
    }
}
#endif
