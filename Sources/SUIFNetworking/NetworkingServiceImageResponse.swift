//
//  NetworkingServiceImageResponse.swift
//  
//
//  Created by Jason Lew-Rapai on 4/16/24.
//

import Foundation
#if os(iOS)
import UIKit.UIImage
#elseif os(macOS)
import AppKit.NSImage
#endif

public struct NetworkingServiceImageResponse {
    #if os(iOS)
    /// The ``UIImage`` from a successful response
    public let image: UIImage
    #elseif os(macOS)
    /// The ``NSImage`` from a successful response
    public let image: NSImage
    #endif
    /// The raw ``Data`` for the image returned from the response
    public let data: Data
    /// The original ``URLResponse`` object for reference
    public let response: URLResponse
}
