//
//  File.swift
//  
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// Button that is styled like a typical URL seen on a web page
///
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
///
/// - **Accessibility**:
///   - Accessibility label for this button is the specified `label` string
///   - Accessibility value for this button is the URL string
@available(*, deprecated, renamed: "Link", message: "Deprecated, use Link instead")
public struct URLButton: View {
    @EnvironmentObject var theme: Theme
    
    private let label: String
    private let url: URL?
    private let multilineTextAlignment: TextAlignment
    private let action: () -> Void
    
    /// Initializes a new `URLButton`
    ///
    /// - Parameters:
    ///   - label: Text for the button
    ///   - multilineTextAlignment: Sets the alignment of multiline text in this view
    ///   - url: The URL destination for the button
    public init(label: String, multilineTextAlignment: TextAlignment = .center, url: URL?) {
        self.label = label
        self.url = url
        self.multilineTextAlignment = multilineTextAlignment
        self.action = {
            guard let url else { return }
            UIApplication.shared.open(url)
        }
    }
    
    /// Initializes a new `URLButton`
    ///
    /// - Parameters:
    ///   - label: Text for the button
    ///   - multilineTextAlignment: Sets the alignment of multiline text in this view
    ///   - action: Closure executed when the button is tapped
    public init(label: String, multilineTextAlignment: TextAlignment = .center, action: @escaping () -> Void) {
        self.label = label
        self.url = nil
        self.multilineTextAlignment = multilineTextAlignment
        self.action = action
    }
    
    public var body: some View {
        if let absoluteString = url?.absoluteString {
            makeBody()
                .accessibilityValue(absoluteString)
        } else {
            makeBody()
        }
    }
    
    private func makeBody() -> some View {
        Button {
            self.action()
        } label: {
            Text(self.label)
                .underline()
                .font(forStyle: .body, weight: .medium)
                .multilineTextAlignment(self.multilineTextAlignment)
        }
        .accentColor(self.theme.colors.accent.color)
        .accessibilityLabel(self.label)
    }
}

#if DEBUG
// MARK: Previews
struct URLButton_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    static var previews: some View {
        Group {
            VStack {
//                URLButton(
//                    label: "Apple",
//                    url: URL(string: "https://www.apple.com"))
                Link("Apple", destination: URL(string: "https://www.apple.com")!)
            }
        }
        .environmentObject(self.theme)
    }
}
#endif
