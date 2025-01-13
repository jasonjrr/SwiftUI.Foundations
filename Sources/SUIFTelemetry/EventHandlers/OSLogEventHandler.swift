//
//  OSLogEventHandler.swift
//
//
//  Created by Jason Lew-Rapai on 4/12/24.
//

import Foundation
import OSLog

extension Telemetry {
    public struct OSLogMetadata {
        public let subsystem: String
        public let category: String
        
        public init(subsystem: String, category: String) {
            self.subsystem = subsystem
            self.category = category
        }
    }
    
    public enum OSLogEvent: Event {
        case debug(metadata: OSLogMetadata, message: String)
        case error(metadata: OSLogMetadata, message: String)
        case log(metadata: OSLogMetadata, logType: OSLogType, message: String)
        case info(metadata: OSLogMetadata, message: String)
        case warning(metadata: OSLogMetadata, message: String)
        case trace(metadata: OSLogMetadata, message: String)
        case notice(metadata: OSLogMetadata, message: String)
        case critical(metadata: OSLogMetadata, message: String)
        case fault(metadata: OSLogMetadata, message: String)
        
        public var metadata: Telemetry.OSLogMetadata {
            switch self {
            case .debug(let metadata, _): return metadata
            case .error(let metadata, _): return metadata
            case .log(let metadata, _, _): return metadata
            case .info(let metadata, _): return metadata
            case .warning(let metadata, _): return metadata
            case .trace(let metadata, _): return metadata
            case .notice(let metadata, _): return metadata
            case .critical(let metadata, _): return metadata
            case .fault(let metadata, _): return metadata
            }
        }
    }
    
    public class OSLogEventHandler: Telemetry.EventHandling {
        public let subsystem: String
        public let category: String
        
        public let logger: Logger
        
        public init(subsystem: String, category: String) {
            self.subsystem = subsystem
            self.category = category
            
            self.logger = Logger(subsystem: subsystem, category: category)
        }
        
        public func onAppLaunch(withOptions launchOptions: [AppLaunchOptionsKey: Any]?) async {}
        
        public func identifyUser(with properties: [String: Any]?) async {}
        
        public func log(_ event: some Telemetry.Event) {
            guard let event = event as? OSLogEvent else {
                return
            }
            let metadata = event.metadata
            guard metadata.subsystem == self.subsystem,
                  metadata.category == self.category
            else {
                return
            }
            
            switch event {
            case .debug(_, let message):
                self.logger.debug("\(message)")
            case .error(_, let message):
                self.logger.error("\(message)")
            case .log(_, let logType, let message):
                self.logger.log(level: logType, "\(message)")
            case .info(_, let message):
                self.logger.info("\(message)")
            case .warning(_, let message):
                self.logger.warning("\(message)")
            case .trace(_, let message):
                self.logger.trace("\(message)")
            case .notice(_, let message):
                self.logger.notice("\(message)")
            case .critical(_, let message):
                self.logger.critical("\(message)")
            case .fault(_, let message):
                self.logger.fault("\(message)")
            }
        }
    }
}
