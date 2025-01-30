//
//  Database.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/29/25.
//

import Foundation
import SwiftData

public protocol Database<T> {
    associatedtype T
    func create(_ item: T) throws
    func create(_ items: [T]) throws
    func read(predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> [T]
    func read(batchSize: Int, predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> FetchResultsCollection<T>
    func update(_ item: T) throws
    func delete(_ item: T) throws
}
