//
//  NetworkingServiceResponse.swift
//
//
//  Created by Jason Lew-Rapai on 4/16/24.
//

import Foundation

public struct NetworkingServiceResponse<Model> where Model: Codable {
    /// The deserialized `Model` from the response
    public let model: Model
    /// The original ``URLResponse`` object for reference
    public let response: URLResponse
}
