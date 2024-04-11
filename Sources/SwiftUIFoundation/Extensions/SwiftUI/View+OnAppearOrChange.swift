//
//  View+OnAppearOrChange.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import SwiftUI

extension View {
    /// Adds a modifier for this view that fires an action when a view appears or
    /// a specific value changes.
    ///
    /// You can use `onAppearOrChange` to trigger a side effect as the result
    /// of a view appering or the value changing, such as an `Environment`
    /// key or a `Binding`.
    ///
    /// `onAppearOrChange` is called on the main thread. Avoid performing long-running
    /// tasks on the main thread. If you need to perform a long-running task in
    /// response to `value` changing, you should dispatch to a background queue.
    ///
    /// The new value is passed into the closure. The previous value may be
    /// captured by the closure to compare it to the new value. For example, in
    /// the following code example, `PlayerView` passes both the old and new
    /// values to the model.
    ///
    ///     struct PlayerView: View {
    ///         var episode: Episode
    ///         @State private var playState: PlayState = .paused
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Text(episode.title)
    ///                 Text(episode.showTitle)
    ///                 PlayButton(playState: $playState)
    ///             }
    ///             .onAppearOrChange(of: playState) { [playState] newState in
    ///                 model.playStateDidChange(from: playState, to: newState)
    ///             }
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///   - value: The value to check against when determining whether
    ///     to run the closure.
    ///   - action: A closure to run when the value changes.
    ///   - newValue: The new value that failed the comparison check.
    ///
    /// - Returns: A view that fires an action when the specified value changes.
    @inlinable public func onAppearOrChange<V>(of value: V, perform action: @escaping (_ newValue: V) -> Void) -> some View where V: Equatable {
        self.onAppear { action(value) }
        .onChange(of: value) { action($0) }
    }
}
