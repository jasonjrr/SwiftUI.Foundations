//
//  SwiftDatabase.swift
//  SwiftUI.Foundations
//
//  Created by Jason Lew-Rapai on 1/29/25.
//

import Foundation
import SwiftData

public protocol SwiftDatabase<T>: Database {
    associatedtype T = PersistentModel
    var container: ModelContainer { get }
}

extension SwiftDatabase {
    public func create<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(self.container)
        context.insert(item)
        try context.save()
    }

    public func create<T: PersistentModel>(_ items: [T]) throws {
        let context = ModelContext(self.container)
        items.forEach {
            context.insert($0)
        }
        try context.save()
    }
    
    public func read<T: PersistentModel>(predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> [T] {
        let context = ModelContext(self.container)
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        return try context.fetch(fetchDescriptor)
    }
    
    public func update<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(self.container)
        context.insert(item)
        try context.save()
    }
    
    public func delete<T: PersistentModel>(_ item: T) throws {
        let context = ModelContext(self.container)
        let idToDelete = item.persistentModelID
        try context.delete(model: T.self, where: #Predicate { item in
            item.persistentModelID == idToDelete
        })
        try context.save()
    }
}
