//
//  RatingView.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

/// `View` that displays stars to represent a rating value. When enabled, the user can choose the rating.
///
/// - **Requirements**:
///   - `Theme`: A `Theme` **must** be injected upstream as an `EnvironmentObject`.
public struct RatingView: View, HapticFeedbackProvidable {
    @Environment(Theme.self) var theme: Theme
    @Binding public var rating: Int
    
    @ScaledMetric private var overrideStarIconHeight: CGFloat = 20.0
    @ScaledMetric private var overrideStarIconWidth: CGFloat = 22.0
    
    private let overrideAccentColor: Color?
    private let overrideSelectedStarIconViewModel: SourcedImageViewModel?
    private let overrideUnselectedStarIconViewModel: SourcedImageViewModel?
    
    /// Initializes a new `RatingView`
    ///
    /// **Note:** You must specify both the `overrideSelectedStarIconViewModel` and
    /// `overrideUnselectedStarIconViewModel` if you wish to override the icons.
    ///
    /// - Parameters:
    ///   - rating: `Binding` to update the current rating value
    ///   - ratingIconColor: Overrides the color for the "star" icon. Defaults to the `Theme`'s accent color.
    ///   - overrideSelectedStarIconViewModel: Overrides the star icon with the image specified when selected
    ///   - overrideUnselectedStarIconViewModel: Overrides the star icon with the image specified when unselected
    public init(
        rating: Binding<Int>,
        ratingIconColor: Color? = nil,
        overrideSelectedStarIconViewModel: SourcedImageViewModel? = nil,
        overrideUnselectedStarIconViewModel: SourcedImageViewModel? = nil
    ) {
        self._rating = rating
        self.overrideAccentColor = ratingIconColor
        self.overrideSelectedStarIconViewModel = overrideSelectedStarIconViewModel
        self.overrideUnselectedStarIconViewModel = overrideUnselectedStarIconViewModel
    }
    
    public var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { value in
                starButton(ratingValue: value)
            }
        }
        .accentColor(self.overrideAccentColor ?? self.theme.colors.accent.color)
        .accessibilityLabel(L10n.Accessibility.RatingView.label)
        .accessibilityValue(L10n.Accessibility.RatingView.rating(value: self.rating))
    }
    
    private func starButton(ratingValue: Int) -> some View {
        Button {
            withAnimation {
                if self.rating == ratingValue {
                    self.rating = 0
                    provideHapticFeedback(.impact(.rigid))
                } else {
                    self.rating = ratingValue
                    provideHapticFeedback(.selection)
                }
            }
        } label: {
            if self.rating >= ratingValue {
                if let overrideSelectedStarIconViewModel {
                    SourcedImageView(viewModel: overrideSelectedStarIconViewModel)
                        .frame(width: self.overrideStarIconWidth, height: self.overrideStarIconHeight)
                } else {
                    Image(systemName: "star.fill")
                }
            } else {
                if let overrideUnselectedStarIconViewModel {
                    SourcedImageView(viewModel: overrideUnselectedStarIconViewModel)
                        .frame(width: self.overrideStarIconWidth, height: self.overrideStarIconHeight)
                } else {
                    Image(systemName: "star")
                }
            }
        }
    }
}

#if DEBUG
// MARK: Previews
struct RatingView_Previews: PreviewProvider {
    static let theme: Theme = Theme()
    static var previews: some View {
        Group {
            RatingView(rating: .constant(3))
        }
        .environment(theme)
    }
}
#endif
