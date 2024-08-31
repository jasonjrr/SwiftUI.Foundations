//
//  BorderedPillButtonStyle.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Pill-shaped button with `accentColor` border
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
public struct BorderedPillButtonStyle: ButtonStyle {
    public enum ErrorState: String, Identifiable, Equatable, Errorable {
        case success
        case error
        
        public var id: String {
            self.rawValue
        }
        
        public var isError: Bool {
            self == .error
        }
    }
    public enum Size: String, Identifiable {
        /// This is smaller than the recomended tap area for a button
        case xsmall
        /// The smallest recommended tap area for a button
        case small
        case medium
        case large
        
        public var id: String {
            self.rawValue
        }
        
        var multiplier: CGFloat {
            switch self {
            case .xsmall: return 0.8
            case .small: return 1.0
            case .medium: return 1.2
            case .large: return 1.5
            }
        }
    }
    
    @Environment(\.isEnabled) private var isEnabled: Bool
    @EnvironmentObject var theme: Theme
    @ScaledMetric private var fontSize: CGFloat = 16.0
    @ScaledMetric private var minWidth: CGFloat = 44.0
    @ScaledMetric private var minHeight: CGFloat = 44.0
    @ScaledMetric private var horizontalContentPadding: CGFloat = 24.0
    @ScaledMetric private var borderWidth: CGFloat = 2.0
    
    private var includeHorizontalPadding: Bool = true
    @State private var isPressed: Bool = false
    
    private let size: Size
    private let errorState: ErrorState?
    private let foregroundColor: UIColor?
    private let backgroundColor: UIColor?
    
    private var errorColor: Color { self.theme.colors.error.color }
    private var successColor: Color { self.theme.colors.success.color }
    
    /// Initializes a new `BorderedPillButtonStyle`
    ///
    /// - Parameters:
    ///   - size: The `Size` of the button. Defaults to `small`
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public init(
        size: Size = .small,
        errorState: ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) {
        self.size = size
        self.errorState = errorState
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }
    
    internal init(
        size: Size = .small,
        errorState: ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        includeHorizontalPadding: Bool
    ) {
        self.init(size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
        self.includeHorizontalPadding = includeHorizontalPadding
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(
                minWidth: self.minWidth * self.size.multiplier,
                minHeight: self.minHeight * self.size.multiplier
            )
            .padding([.leading, .trailing], self.includeHorizontalPadding ? self.horizontalContentPadding : 0.0)
            .contentShape(Capsule())
            .foregroundColor(self.getForegroundColor())
            .font(ofSize: self.fontSize * self.size.multiplier, weight: .semibold)
            .overlay {
                Capsule()
                    .stroke(self.getForegroundColor(), lineWidth: self.borderWidth)
                    .padding(self.borderWidth / 2.0)
            }
            .background {
                (self.backgroundColor?.color ?? .clear)
                    .clipShape(Capsule())
            }
            .opacity(self.isPressed ? 0.5 : 1.0)
            .opacity(self.isEnabled ? 1.0 : self.theme.constants.disabledOpacity)
            .accentColor(self.foregroundColor?.color ?? self.theme.colors.accent.color)
            .onChange(of: configuration.isPressed) { isPressed in
                withAnimation(.easeInOut(duration: 0.065)) {
                    self.isPressed = isPressed
                }
            }
    }
    
    private func getForegroundColor() -> Color {
        switch self.errorState {
        case .none:
            return self.foregroundColor?.color ?? self.theme.colors.accent.color
        case .error:
            return self.errorColor
        case .success:
            return self.successColor
        }
    }
}

extension ButtonStyle where Self == BorderedPillButtonStyle {
    /// Pill-shaped button with `accentColor` border.
    public static var borderedPill: Self {
        BorderedPillButtonStyle()
    }
    
    /// Pill-shaped button with `foregroundColor` border.
    ///
    /// - Parameters:
    ///   - size: The `Size` of the button. Defaults to `small`
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public static func borderedPill(
        size: BorderedPillButtonStyle.Size = .small,
        errorState: BorderedPillButtonStyle.ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) -> Self {
        BorderedPillButtonStyle(size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }
    
    /// Pill-shaped button with `accentColor` border.
    /// **Note**: The styled button should wrap a single `Image` view and
    /// the image contained within should be square.
    public static var borderedPillIcon: Self {
        BorderedPillButtonStyle(includeHorizontalPadding: false)
    }
    
    /// Pill-shaped button with `foregroundColor` border.
    /// **Note**: The styled button should wrap a single `Image` view and
    /// the image contained within should be square.
    ///
    /// - Parameters:
    ///   - size: The `Size` of the button. Defaults to `small`
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public static func borderedPillIcon(
        size: BorderedPillButtonStyle.Size = .small,
        errorState: BorderedPillButtonStyle.ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) -> Self {
        BorderedPillButtonStyle(size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor, includeHorizontalPadding: false)
    }
}

extension ButtonStyle where Self == BorderedPillButtonStyle {
    /// Design System `secondary` button style
    public static var secondary: Self {
        BorderedPillButtonStyle()
    }
}

#if DEBUG
// MARK: Previews
struct BorderedPillButtonStyle_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    
    static var previews: some View {
        // MARK: Size
        Group {
            VStack {
                Button { /* Action*/ } label: {
                    Text("Large")
                }
                .buttonStyle(.borderedPill(size: .large))
                Button { /* Action*/ } label: {
                    Text("Medium")
                }
                .buttonStyle(.borderedPill(size: .medium))
                Button { /* Action*/ } label: {
                    Text("Small")
                }
                .buttonStyle(.borderedPill(size: .small))
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(size: .large))
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(size: .medium))
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(size: .small))
            }
        }
        .previewDisplayName("Size")
        .environmentObject(theme)
        
        // MARK: Disabled
        Group {
            HStack {
                Button { /* Action*/ } label: {
                    Text("Disabled")
                }
                .buttonStyle(.borderedPill)
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon)
            }
            .disabled(true)
        }
        .previewDisplayName("Disabled")
        .environmentObject(theme)
        
        // MARK: Success / Error
        Group {
            VStack {
                Button { /* Action*/ } label: {
                    Text("None")
                }
                .buttonStyle(.borderedPill(errorState: .none))
                
                Button { /* Action*/ } label: {
                    Text("Error")
                }
                .buttonStyle(.borderedPill(errorState: .error))
                
                Button { /* Action*/ } label: {
                    Text("Success")
                }
                .buttonStyle(.borderedPill(errorState: .success))
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(errorState: .none))
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(errorState: .error))
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.borderedPillIcon(errorState: .success))
            }
        }
        .previewDisplayName("Success/Error")
        .environmentObject(theme)
    }
}
#endif
