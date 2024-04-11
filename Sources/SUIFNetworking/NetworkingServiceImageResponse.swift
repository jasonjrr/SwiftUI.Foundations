//
//  NetworkingServiceImageResponse.swift
//  
//
//  Created by Jason Lew-Rapai on 4/16/24.
//

import Foundation
import UIKit.UIImage

public struct NetworkingServiceImageResponse {
    /// The ``UIImage`` from a successful response
    public let image: UIImage
    /// The raw ``Data`` for the image returned from the response
    public let data: Data
    /// The original ``URLResponse`` object for reference
    public let response: URLResponse
}
