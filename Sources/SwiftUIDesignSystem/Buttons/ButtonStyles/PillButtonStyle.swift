//
//  PillButtonStyle.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Pill-shaped button with a solid background
///
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
public struct PillButtonStyle: ButtonStyle {
    public enum Kind: String, Identifiable {
        /// `accentColor` background
        case primary
        /// `secondaryColor` background
        case secondary
        /// `Color.clear` background and `accentColor` text
        case tertiary
        
        public var id: String {
            self.rawValue
        }
    }
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
    public enum Size: String, Identifiable, Equatable {
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
    
    @Environment(\.isEnabled) var isEnabled
    @EnvironmentObject var theme: Theme
    @ScaledMetric private var fontSize: CGFloat = 16.0
    @ScaledMetric private var minWidth: CGFloat = 44.0
    @ScaledMetric private var minHeight: CGFloat = 44.0
    @ScaledMetric private var horizontalContentPadding: CGFloat = 24.0
    
    private var includeHorizontalPadding: Bool = true
    @State private var isPressed: Bool = false
    
    private let kind: Kind
    private let size: Size
    private let errorState: ErrorState?
    private let overrideForegroundColor: UIColor?
    private let overrideBackgroundColor: UIColor?
    
    private var fillColor: Color {
        let uiColor: UIColor
        switch self.errorState {
        case .none:
            switch self.kind {
            case .primary:
                uiColor = self.overrideBackgroundColor ?? self.theme.colors.accent
            case .secondary:
                uiColor = self.overrideBackgroundColor ?? self.theme.colors.secondary
            case .tertiary:
                uiColor = self.overrideBackgroundColor ?? .clear
            }
        case .error:
            uiColor = self.theme.colors.error
        case .success:
            uiColor = self.theme.colors.success
        }
        return uiColor.color
    }
    
    private var foregroundColor: Color {
        let uiColor: UIColor
        switch self.kind {
        case .primary, .secondary:
            uiColor = self.overrideForegroundColor ?? self.theme.colors.buttonForeground
        case .tertiary:
            uiColor = self.overrideForegroundColor ?? self.theme.colors.accent
        }
        return uiColor.color
    }
    
    /// Initializes a new `PillButtonStyle`
    ///
    /// - Parameters:
    ///   - kind: Determines the background color of the button
    ///   - size: The `Size` of the button. Defaults to `small`
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public init(
        kind: Kind,
        size: Size,
        errorState: ErrorState?,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) {
        self.kind = kind
        self.size = size
        self.errorState = errorState
        self.overrideForegroundColor = foregroundColor
        self.overrideBackgroundColor = backgroundColor
    }
    
    internal init(
        kind: Kind,
        size: Size = .small,
        errorState: ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        includeHorizontalPadding: Bool) {
        self.init(kind: kind, size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
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
            .foregroundColor(self.foregroundColor)
            .font(ofSize: self.fontSize * self.size.multiplier, weight: .semibold)
            .background {
                Capsule(style: .circular).fill(self.fillColor)
            }
            .compositingGroup()
            .opacity(self.isPressed ? 0.5 : 1.0)
            .opacity(self.isEnabled ? 1.0 : self.theme.constants.disabledOpacity)
            .onChange(of: configuration.isPressed) { isPressed in
                withAnimation(.easeInOut(duration: 0.065)) {
                    self.isPressed = isPressed
                }
            }
    }
}

extension ButtonStyle where Self == PillButtonStyle {
    /// Pill-shaped button with a solid background.
    public static var pill: Self {
        self.pill()
    }
    
    /// Pill-shaped button with a solid background.
    ///
    /// - Parameters:
    ///   - kind: Determines the background color of the button. Defaults to `primary`.
    ///   - size: The `Size` of the button. Defaults to `small`. Defaults to `small`.
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public static func pill(
        kind: PillButtonStyle.Kind = .primary,
        size: PillButtonStyle.Size = .small,
        errorState: PillButtonStyle.ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) -> Self {
        PillButtonStyle(kind: kind, size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor)
    }
    
    /// Pill-shaped button with a solid background.
    /// **Note**: The styled button should wrap a single `Image` view and
    /// the image contained within should be square.
    public static var pillIcon: Self {
        PillButtonStyle(kind: .primary, includeHorizontalPadding: false)
    }
    
    /// Pill-shaped button with a solid background.
    /// **Note**: The styled button should wrap a single `Image` view and
    /// the image contained within should be square.
    ///
    /// - Parameters:
    ///   - kind: Determines the background color of the button. Defaults to `primary`.
    ///   - size: The `Size` of the button. Defaults to `small`. Defaults to `small`.
    ///   - errorState: The `errorState` of the button. Defaults to `nil` meaning there is no relevant error state.
    ///   - foregroundColor: Overrides the button's `accentColor` for the content and border.
    ///   - backgroundColor: The color behind the button's content.
    public static func pillIcon(
        kind: PillButtonStyle.Kind = .primary,
        size: PillButtonStyle.Size = .small,
        errorState: PillButtonStyle.ErrorState? = nil,
        foregroundColor: UIColor? = nil,
        backgroundColor: UIColor? = nil
    ) -> Self {
        PillButtonStyle(kind: kind, size: size, errorState: errorState, foregroundColor: foregroundColor, backgroundColor: backgroundColor, includeHorizontalPadding: false)
    }
}

extension ButtonStyle where Self == PillButtonStyle {
    /// Design System `primary` button style
    public static var primary: Self {
        PillButtonStyle(kind: .primary, size: .small, errorState: nil)
    }
    
    /// Design System `tertiary` button style
    public static var tertiary: Self {
        PillButtonStyle(kind: .tertiary, size: .small, errorState: nil, includeHorizontalPadding: false)
    }
}

#if DEBUG
// MARK: Previews
struct PillButtonStyle_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    
    static var previews: some View {
        // MARK: Button Kinds
        Group {
            VStack {
                HStack {
                    Button { /* Action*/ } label: {
                        Text("Primary")
                    }
                    .buttonStyle(.pill(kind: .primary))
                    Button { /* Action*/ } label: {
                        Text("Secondary")
                    }
                    .buttonStyle(.pill(kind: .secondary))
                }
                HStack {
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(kind: .primary))
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(kind: .secondary))
                }
            }
        }
        .previewDisplayName("Button Kinds")
        .environmentObject(theme)
        
        // MARK: Size
        Group {
            VStack {
                Button { /* Action*/ } label: {
                    Text("Large")
                }
                .buttonStyle(.pill(size: .large))
                Button { /* Action*/ } label: {
                    Text("Medium")
                }
                .buttonStyle(.pill(size: .medium))
                Button { /* Action*/ } label: {
                    Text("Small")
                }
                .buttonStyle(.pill(size: .small))
                
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.pillIcon(size: .large))
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.pillIcon(size: .medium))
                Button { /* Action*/ } label: {
                    Image(systemName: "person")
                }
                .buttonStyle(.pillIcon(size: .small))
            }
        }
        .previewDisplayName("Size")
        .environmentObject(theme)
        
        // MARK: Disabled
        Group {
            VStack {
                HStack {
                    Button { /* Action*/ } label: {
                        Text("Primary")
                    }
                    .buttonStyle(.pill(kind: .primary))
                    Button { /* Action*/ } label: {
                        Text("Secondary")
                    }
                    .buttonStyle(.pill(kind: .secondary))
                }
                HStack {
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(kind: .primary))
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(kind: .secondary))
                }
            }
            .disabled(true)
        }
        .previewDisplayName("Disabled")
        .environmentObject(theme)
        
        // MARK: Success / Error
        Group {
            VStack {
                HStack {
                    Button { /* Action*/ } label: {
                        Text("None")
                    }
                    .buttonStyle(.pill(errorState: .none))
                    Button { /* Action*/ } label: {
                        Text("Error")
                    }
                    .buttonStyle(.pill(errorState: .error))
                    Button { /* Action*/ } label: {
                        Text("Success")
                    }
                    .buttonStyle(.pill(errorState: .success))
                }
                HStack {
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(errorState: .none))
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(errorState: .error))
                    Button { /* Action*/ } label: {
                        Image(systemName: "person")
                    }
                    .buttonStyle(.pillIcon(errorState: .success))
                }
            }
        }
        .previewDisplayName("Success/Error")
        .environmentObject(theme)
    }
}
#endif
