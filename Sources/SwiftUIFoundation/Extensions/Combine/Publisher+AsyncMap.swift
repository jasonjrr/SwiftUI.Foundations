//
//  Publisher+AsyncMap.swift
//
//
//  Created by Jason Lew-Rapai on 4/11/24.
//

import Combine
import CombineExt

extension Publisher {
    /// Maps the parent Publisher's `Output` to `T` via the `transform` closure
    ///
    /// - Parameters:
    ///     - `transform`: the closure that can execute async code and returns a value of type `T`
    ///
    /// - Returns: a new Publisher where the `Output` is of type `T`
    public func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Deferred<Future<T, Never>>, Self> {
        flatMap { value in
            Deferred {
                Future { promise in
                    Task {
                        let output = await transform(value)
                        promise(.success(output))
                    }
                }
            }
        }
    }
    
    /// Maps the parent Publisher's `Output` to `T` via the `transform` closure
    ///
    /// - Parameters:
    ///     - `transform`: the closure that can execute async code and returns a value of type `T`
    ///
    /// - Returns: a new Publisher where the `Output` is of type `T`
    public func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Deferred<Future<T, Error>>, Self> {
        flatMap { value in
            Deferred {
                Future { promise in
                    Task {
                        do {
                            let output = try await transform(value)
                            promise(.success(output))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    /// Maps the parent Publisher's `Output` to `T` via the `transform` closure
    ///
    /// - Parameters:
    ///     - `transform`: the closure that can execute async code and returns a value of type `T`
    ///
    /// - Returns: a new Publisher where the `Output` is of type `T`
    public func tryAsyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Deferred<Future<T, Error>>, Publishers.SetFailureType<Self, Error>> {
        flatMap { value in
            Deferred {
                Future { promise in
                    Task {
                        do {
                            let output = try await transform(value)
                            promise(.success(output))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
        }
    }
}
