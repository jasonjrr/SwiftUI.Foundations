//
//  TelemetryEventHandler.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation

extension Telemetry {
    public protocol EventHandling {
        func log(_ event: some Telemetry.Event) async
    }
}
