//
//  SwiftUIDesignSystemResources.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Foundation

final class SwiftUIDesignSystemResources {
    static let resourceBundle: Bundle = {
        #if SWIFT_PACKAGE
        return .module
        #else
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: SwiftUIDesignSystemResources.self).resourceURL,
        ]

        let bundlePath = "SFDesignSystem_SFDesignSystem.bundle"

        for candidate in candidates {
            let resourceURL: URL?
            if #available(iOS 16.0, *) {
                resourceURL = candidate?.appending(path: bundlePath)
            } else {
                resourceURL = candidate?.appendingPathComponent(bundlePath)
            }

            if let resourceURL, let bundle = Bundle(url: resourceURL) {
                return bundle
            }
        }

        // Return whatever bundle this code is in as a last resort.
        return Bundle(for: SwiftUIDesignSystemResources.self)
        #endif
    }()
}
