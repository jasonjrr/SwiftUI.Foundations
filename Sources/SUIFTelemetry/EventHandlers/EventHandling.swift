//
//  TelemetryEventHandler.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import UIKit

extension Telemetry {
    public typealias AppLaunchOptionsKey = UIApplication.LaunchOptionsKey
    
    public protocol EventHandling {
        func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?) async
        func identifyUser(with properties: [String: Any]?) async
        func log(_ event: some Telemetry.Event) async
    }
}
