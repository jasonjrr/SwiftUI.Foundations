//
//  PrintEventHandler.swift
//  
//
//  Created by Jason Lew-Rapai on 4/13/24.
//

import Foundation

extension Telemetry {
    public struct PrintEventHandler: Telemetry.EventHandling {
        public func log(_ event: some Telemetry.Event) {
            print("Telemetry.Log: \(event)")
        }
    }
}
