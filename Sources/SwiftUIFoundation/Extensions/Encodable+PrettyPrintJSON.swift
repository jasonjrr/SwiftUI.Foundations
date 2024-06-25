//
//  Encodable+PrettyPrintJSON.swift
//
//
//  Created by Jason Lew-Rapai on 6/24/24.
//

import Foundation

extension Encodable {
    public func prettyPrintJSON() -> String {
        guard let data = try? JSONEncoder().encode(self),
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
            return .empty
        }
        return String(decoding: jsonData, as: UTF8.self)
    }
}
