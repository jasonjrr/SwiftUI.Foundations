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
    public func create<T: PersistentModel>(_ item: T, transactionContext: ModelContext? = nil) throws {
        let context = transactionContext ?? ModelContext(self.container)
        context.insert(item)
        if transactionContext == nil {
            try context.save()
        }
    }

    public func create<T: PersistentModel>(_ items: [T], transactionContext: ModelContext? = nil) throws {
        let context = transactionContext ?? ModelContext(self.container)
        items.forEach {
            context.insert($0)
        }
        if transactionContext == nil {
            try context.save()
        }
    }
    
    public func read<T: PersistentModel>(predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> [T] {
        let context = ModelContext(self.container)
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        return try context.fetch(fetchDescriptor)
    }
    
    public func read<T: PersistentModel>(batchSize: Int, predicate: Predicate<T>?, sortDescriptors: SortDescriptor<T>...) throws -> FetchResultsCollection<T> {
        let context = ModelContext(self.container)
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortDescriptors)
        return try context.fetch(fetchDescriptor, batchSize: batchSize)
    }
    
    public func update<T: PersistentModel>(_ item: T, transactionContext: ModelContext? = nil) throws {
        let context = transactionContext ?? ModelContext(self.container)
        context.insert(item)
        if transactionContext == nil {
            try context.save()
        }
    }
    
    public func delete<T: PersistentModel>(_ item: T, transactionContext: ModelContext? = nil) throws {
        let context = transactionContext ?? ModelContext(self.container)
        let idToDelete = item.persistentModelID
        try context.delete(model: T.self, where: #Predicate { item in
            item.persistentModelID == idToDelete
        })
        if transactionContext == nil {
            try context.save()
        }
    }
    
    public func delete<T: PersistentModel>(_ items: [T]) throws {
        let context = ModelContext(self.container)
        let idsToDelete = items.map { $0.persistentModelID }
  
        try context.transaction {
            var models: [T] = []
            for id in idsToDelete {
                let model = try read(predicate: #Predicate { (model: T) in
                    model.persistentModelID == id
                })
            }
            models.forEach { model in
                context.delete(model)
            }
        }
        
//        try context.transaction {
//            for id in idsToDelete {
//                try context.delete(model: T.self, where: #Predicate { item in
//                    item.persistentModelID == id
//                })
//            }
//        }

//        print("Will I delete anything? \(context.hasChanges)")
//        
//        try context.save()
    }
}
