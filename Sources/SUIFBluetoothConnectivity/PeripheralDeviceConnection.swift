//
//  PeripheralDeviceConnection.swift
//
//
//  Created by Jason Lew-Rapai on 8/28/24.
//

import Foundation
import CoreBluetooth
import Combine

extension Bluetooth {
    ///
    /// Public class representing a connection to a peripheral device.
    ///
    /// This class manages services, characteristics, and descriptors for a peripheral device.
    ///
    public class PeripheralDeviceConnection: NSObject, Identifiable {
        /// The peripheral device associated with the connection.
        public let device: PeripheralDevice
        
        /// The unique identifier for the connection.
        public var id: UUID { self.device.id }
        
        private let _services: CurrentValueSubject<Result<[CBService], any Error>?, Never> = CurrentValueSubject(nil)
        private let _characteristicsByServiceUUID: CurrentValueSubject<[CBUUID: Result<[CBCharacteristic], any Error>], Never> = CurrentValueSubject([:])
        private let _valueSubjectsByCharacteristicUUID: CurrentValueSubject<[CBUUID: CurrentValueSubject<Result<Data?, any Error>, Never>], Never> = CurrentValueSubject([:])
        private let _descriptorsByCharacteristicUUID: CurrentValueSubject<[CBUUID: Result<[CBDescriptor], any Error>], Never> = CurrentValueSubject([:])
        
        private let canSendWriteWithoutResponse: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
        
        private let dispatchQueue: DispatchQueue = DispatchQueue.global(qos: .userInitiated)
        private var cancellables: Set<AnyCancellable> = []
        
        ///
        /// Initializes a new PeripheralDeviceConnection with the given peripheral device.
        ///
        /// - Parameter device: The peripheral device to establish a connection with.
        ///
        init(device: PeripheralDevice) {
            self.device = device
            super.init()
            device.peripheral.delegate = self
        }
        
        ///
        /// Discovers services for the peripheral device.
        ///
        /// - Parameter serviceUUIDs: An array of CBUUID services to discover.
        /// - Returns: A publisher that emits the result of service discovery.
        ///
        @discardableResult
        public func discoverService(
            _ serviceUUIDs: [CBUUID]? = nil
        ) -> AnyPublisher<Result<[CBService], any Error>?, Never> {
            self.device.peripheral.discoverServices(serviceUUIDs)
            return self._services.eraseToAnyPublisher()
        }
        
        ///
        /// Discovers characteristics for a specified service.
        ///
        /// - Parameter characteristicUUIDs: An array of CBUUID characteristics to discover.
        /// - Parameter service: The service to discover characteristics for.
        /// - Returns: A publisher that emits the result of characteristic discovery.
        ///
        @discardableResult
        public func discoverCharacteristics(
            _ characteristicUUIDs: [CBUUID]? = nil,
            for service: CBService
        ) -> AnyPublisher<Result<[CBCharacteristic], any Error>?, Never> {
            self.device.peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
            return self._characteristicsByServiceUUID
                .compactMap { $0[service.uuid] }
                .eraseToAnyPublisher()
        }
        
        ///
        /// Observes changes in a characteristic's value.
        ///
        /// - Parameter characteristic: The characteristic to observe.
        /// - Returns: A publisher that emits the result of the characteristic's value change.
        ///
        public func observeCharacteristic(
            _ characteristic: CBCharacteristic
        ) -> AnyPublisher<Result<Data?, any Error>, Never> {
            Just(())
                .receive(on: self.dispatchQueue)
                .withLatestFrom(self._valueSubjectsByCharacteristicUUID)
                .flatMapLatest { [weak self] valueSubjectsByCharacteristicUUID in
                    if let valueSubject = valueSubjectsByCharacteristicUUID[characteristic.uuid] {
                        return valueSubject
                    } else {
                        let valueSubject: CurrentValueSubject<Result<Data?, any Error>, Never> = CurrentValueSubject(.success(nil))
                        var valueSubjectsByCharacteristicUUID = valueSubjectsByCharacteristicUUID
                        valueSubjectsByCharacteristicUUID[characteristic.uuid] = valueSubject
                        self?._valueSubjectsByCharacteristicUUID.send(valueSubjectsByCharacteristicUUID)
                        self?.device.peripheral.setNotifyValue(true, for: characteristic)
                        return valueSubject
                    }
                }
                .eraseToAnyPublisher()
        }
        
        ///
        /// Writes data to a characteristic.
        ///
        /// - Parameter data: The data to write.
        /// - Parameter characteristic: The characteristic to write to.
        /// - Returns: A publisher that emits the result of the characteristic's value change.
        ///
        @discardableResult
        public func writeToCharacteristic(
            _ data: Data,
            for characteristic: CBCharacteristic
        ) -> AnyPublisher<Result<Data?, any Error>, Never> {
            Just(())
                .receive(on: self.dispatchQueue)
                .withLatestFrom(self.canSendWriteWithoutResponse.filter { $0 })
                .sink(receiveValue: { [weak self] _ in
                    self?.canSendWriteWithoutResponse.send(false)
                    self?.device.peripheral.writeValue(data, for: characteristic, type: .withResponse)
                })
                .store(in: &self.cancellables)
            return observeCharacteristic(characteristic)
        }
        
        ///
        /// Discovers descriptors for a characteristic.
        ///
        /// - Parameter characteristic: The characteristic to discover descriptors for.
        /// - Returns: A publisher that emits the result of descriptor discovery.
        ///
        @discardableResult
        public func discoverDescriptors(
            for characteristic: CBCharacteristic
        ) -> AnyPublisher<Result<[CBDescriptor], any Error>?, Never> {
            self.device.peripheral.discoverDescriptors(for: characteristic)
            return self._descriptorsByCharacteristicUUID
                .compactMap { $0[characteristic.uuid] }
                .eraseToAnyPublisher()
        }
    }
}

// MARK: CBPeripheralDelegate
extension Bluetooth.PeripheralDeviceConnection: CBPeripheralDelegate {
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        if let error {
            self._services.send(.failure(error))
        } else if let services = peripheral.services {
            self._services.send(.success(services))
        } else {
            self._services.send(nil)
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._characteristicsByServiceUUID)
            .sink(receiveValue: { characteristicsByServiceUUID in
                var characteristicsByServiceUUID = characteristicsByServiceUUID
                if let error {
                    characteristicsByServiceUUID[service.uuid] = .failure(error)
                } else if let characteristics = service.characteristics {
                    characteristicsByServiceUUID[service.uuid] = .success(characteristics)
                } else {
                    characteristicsByServiceUUID[service.uuid] = nil
                }
                self._characteristicsByServiceUUID.send(characteristicsByServiceUUID)
            })
            .store(in: &self.cancellables)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._valueSubjectsByCharacteristicUUID)
            .sink(receiveValue: { valueSubjectsByCharacteristicUUID in
                let valueSubjectsByCharacteristicUUID = valueSubjectsByCharacteristicUUID
                if let error {
                    valueSubjectsByCharacteristicUUID[characteristic.uuid]?.send(.failure(error))
                } else {
                    valueSubjectsByCharacteristicUUID[characteristic.uuid]?.send(.success(characteristic.value))
                }
                self._valueSubjectsByCharacteristicUUID.send(valueSubjectsByCharacteristicUUID)
            })
            .store(in: &self.cancellables)
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: (any Error)?) {
        Just(())
            .receive(on: self.dispatchQueue)
            .withLatestFrom(self._descriptorsByCharacteristicUUID)
            .sink(receiveValue: { descriptorsByCharacteristicUUID in
                var descriptorsByCharacteristicUUID = descriptorsByCharacteristicUUID
                if let error {
                    descriptorsByCharacteristicUUID[characteristic.uuid] = .failure(error)
                } else if let descriptors = characteristic.descriptors {
                    descriptorsByCharacteristicUUID[characteristic.uuid] = .success(descriptors)
                } else {
                    descriptorsByCharacteristicUUID[characteristic.uuid] = nil
                }
                self._descriptorsByCharacteristicUUID.send(descriptorsByCharacteristicUUID)
            })
            .store(in: &self.cancellables)
    }
    
    public func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        Just(())
            .receive(on: self.dispatchQueue)
            .sink(receiveValue: { [weak self] in
                self?.canSendWriteWithoutResponse.send(true)
            })
            .store(in: &self.cancellables)
    }
}
