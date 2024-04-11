//
//  NetworkingServiceError.swift
//  
//
//  Created by Jason Lew-Rapai on 4/16/24.
//

import Foundation

/// Errors that occur while handling `NetworkService` responses
public enum NetworkingServiceError: LocalizedError {
    case malformedURL
    case failedToCreateImageFromData
}
