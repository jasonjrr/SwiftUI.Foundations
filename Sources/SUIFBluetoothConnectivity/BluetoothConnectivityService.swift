//
//  BluetoothConnectivityService.swift
//
//
//  Created by Jason Lew-Rapai on 8/26/24.
//

import Foundation
import CoreBluetooth
import Combine
import CombineExt

extension Bluetooth {
    ///
    /// ``Protocol`` for managing Bluetooth connectivity services.
    ///
    public protocol BluetoothConnectivityServiceProtocol: AnyObject {
        
        ///
        /// Scans for peripherals with specified services.
        ///
        /// - Parameter services: An array of ``CBUUID`` services to scan for.
        /// - Returns: A ``Publisher`` that emits an array of `PeripheralDevice` when scanning completes.
        ///
        func scanForPeripherals(withServices services: [CBUUID]?, with options: [ScanOption]?) -> AnyPublisher<[Bluetooth.PeripheralDevice], Never>
        
        ///
        /// Stops scanning for peripherals.
        ///
        func stopScanning()
        
        ///
        /// Connects to a peripheral device.
        ///
        /// - Parameter device: The `PeripheralDevice` to connect to.
        /// - Returns: A ``Publisher`` that emits a `PeripheralDeviceConnectionRequest` when connection is established.
        ///
        func connect(to device: PeripheralDevice) -> AnyPublisher<PeripheralDeviceConnectionRequest?, Never>
        
        ///
        /// Cancels a connection request.
        ///
        /// - Parameter request: The `PeripheralDeviceConnectionRequest` to cancel.
        ///
        func cancelConnectionRequest(_ request: PeripheralDeviceConnectionRequest)
    }
}

extension Bluetooth.BluetoothConnectivityServiceProtocol {
    func scanForPeripherals(withServices services: [CBUUID]? = nil, with options: [Bluetooth.ScanOption]? = nil) -> AnyPublisher<[Bluetooth.PeripheralDevice], Never> {
        scanForPeripherals(withServices: services, with: options)
    }
}

extension Bluetooth {
    public class BluetoothConnectivityService: NSObject, BluetoothConnectivityServiceProtocol {
        private var centralManager: CBCentralManager!
        
        private let _state: CurrentValueSubject<CBManagerState, Never> = CurrentValueSubject(.unknown)
        
        private var scanningPackage: ScanningPublisherPackage?
        private var scanTimer: Timer?
        private var _discoveredDevices: CurrentValueSubject<[PeripheralDevice], Never>?
        
        private let _deviceConnectionRequests: CurrentValueSubject<[UUID: PeripheralDeviceConnectionRequest], Never> = CurrentValueSubject([:])
        
        private let dispatchQueue: DispatchQueue
        private var cancellables: Set<AnyCancellable> = []
        
        public init(queue: DispatchQueue? = DispatchQueue.global(qos: .userInitiated)) {
            self.dispatchQueue = queue ?? DispatchQueue.global(qos: .userInitiated)
            super.init()
            self.centralManager = CBCentralManager(delegate: self, queue: queue)
        }
        
        public func scanForPeripherals(withServices services: [CBUUID]? = nil, with options: [ScanOption]? = nil) -> AnyPublisher<[PeripheralDevice], Never> {
            if let scanningPackage = self.scanningPackage,
               scanningPackage.services == services,
               scanningPackage.options == options {
                return scanningPackage.publisher
            } else {
                stopScanning()
                let publisher = self._state
                    .receive(on: self.dispatchQueue)
                    .filter { $0 == .poweredOn }
                    .flatMapLatest { [weak self, centralManager] _ -> AnyPublisher<[PeripheralDevice], Never> in
                        guard let self else {
                            return Just([]).eraseToAnyPublisher()
                        }
                        if let _discoveredDevices = self._discoveredDevices {
                            return _discoveredDevices.eraseToAnyPublisher()
                        } else {
                            let subject: CurrentValueSubject<[PeripheralDevice], Never> = CurrentValueSubject([])
                            self._discoveredDevices = subject
                            self._deviceConnectionRequests.send([:])
                            centralManager?.scanForPeripherals(withServices: services, options: options?.toDictionary())
                            self.scanTimer?.invalidate()
                            self.scanTimer = Timer
                                .scheduledTimer(withTimeInterval: 2.0, repeats: true) { [centralManager] _ in
                                    centralManager?.stopScan()
                                    centralManager?.scanForPeripherals(withServices: services, options: options?.toDictionary())
                                }
                            return subject.eraseToAnyPublisher()
                        }
                    }
                    .share(replay: 1)
                    .eraseToAnyPublisher()
                self.scanningPackage = ScanningPublisherPackage(publisher: publisher, services: services, options: options)
                return publisher
            }
        }
        
        public func stopScanning() {
            Just(())
                .receive(on: self.dispatchQueue)
                .sink(receiveValue: { [weak self] in
                    self?.scanTimer?.invalidate()
                    self?.centralManager.stopScan()
                    self?.scanningPackage = nil
                    self?._discoveredDevices?.send(completion: .finished)
                    self?._discoveredDevices = nil
                })
                .store(in: &self.cancellables)
        }
        
        public func connect(to device: PeripheralDevice) -> AnyPublisher<PeripheralDeviceConnectionRequest?, Never> {
            Just(())
                .receive(on: self.dispatchQueue)
                .withLatestFrom(self._deviceConnectionRequests)
                .sink(receiveValue: { [weak self, centralManager] requests in
                    var requests = requests
                    requests[device.id] = PeripheralDeviceConnectionRequest(device: device)
                    self?._deviceConnectionRequests.send(requests)
                    centralManager?.connect(device.peripheral, options: nil)
                })
                .store(in: &self.cancellables)
            
            return self._deviceConnectionRequests
                .map { requests in
                    requests[device.id]
                }
                .removeDuplicates()
                .eraseToAnyPublisher()
        }
        
        public func cancelConnectionRequest(_ request: PeripheralDeviceConnectionRequest) {
            Just(())
                .receive(on: self.dispatchQueue)
                .withLatestFrom(self._deviceConnectionRequests)
                .sink(receiveValue: { [weak self, centralManager] requests in
                    var requests = requests
                    requests[request.device.id] = nil
                    self?._deviceConnectionRequests.send(requests)
                    centralManager?.cancelPeripheralConnection(request.device.peripheral)
                })
                .store(in: &self.cancellables)
        }
    }
}

// MARK: CBCentralManagerDelegate
extension Bluetooth.BluetoothConnectivityService: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self._state.send(central.state)
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard let _discoveredDevices else {
            // Not scanning
            return
        }
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(_discoveredDevices)
            .sink(receiveValue: { discoveredDevices in
                var discoveredDevices = discoveredDevices
                discoveredDevices.append(Bluetooth.PeripheralDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI.intValue))
                _discoveredDevices.send(discoveredDevices)
            })
            .store(in: &self.cancellables)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._deviceConnectionRequests)
            .sink(receiveValue: { requests in
                var requests = requests
                if var request = requests[peripheral.identifier], let error {
                    request.state = .error(error)
                    requests[peripheral.identifier] = request
                } else {
                    // TODO: No request found!!!
                }
                self._deviceConnectionRequests.send(requests)
            })
            .store(in: &self.cancellables)
    }
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._deviceConnectionRequests)
            .sink(receiveValue: { [weak self] requests in
                if var request = requests[peripheral.identifier] {
                    var requests = requests
                    request.state = .connected(Bluetooth.PeripheralDeviceConnection(device: request.device))
                    requests[peripheral.identifier] = request
                    self?._deviceConnectionRequests.send(requests)
                } else {
                    // TODO: No request found!!!
                }
            })
            .store(in: &self.cancellables)
    }
    
    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._deviceConnectionRequests)
            .sink(receiveValue: { [weak self] requests in
                if let error {
                    var requests = requests
                    var request = requests[peripheral.identifier]
                    request?.state = .error(error)
                    requests[peripheral.identifier] = request
                    self?._deviceConnectionRequests.send(requests)
                } else {
                    var requests = requests
                    requests[peripheral.identifier] = nil
                    self?._deviceConnectionRequests.send(requests)
                }
            })
            .store(in: &self.cancellables)
    }
}

extension Bluetooth.BluetoothConnectivityService {
    struct ScanningPublisherPackage: Equatable {
        let publisher: AnyPublisher<[Bluetooth.PeripheralDevice], Never>
        let services: [CBUUID]?
        let options: [Bluetooth.ScanOption]?
        
        static func == (lhs: ScanningPublisherPackage, rhs: ScanningPublisherPackage) -> Bool {
            lhs.services == rhs.services
            && lhs.options == rhs.options
        }
    }
}

extension CBManagerState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .resetting:
            return "resetting"
        case .unsupported:
            return "unsupported"
        case .unauthorized:
            return "unauthorized"
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        @unknown default:
            return "unknown"
        }
    }
}
