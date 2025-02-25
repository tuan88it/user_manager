//
//  CoreDataHelpers.swift
//  LocalStorage
//
//  Created by nguyen minh tuan on 2/19/25.
//

// MARK: - ManagedEntity
import CoreData

protocol ManagedEntity: NSFetchRequestResult { }

extension ManagedEntity where Self: NSManagedObject {
    
    static var entityName: String {
        return String(describing: Self.self)
    }
    
    static func insertNew(in context: NSManagedObjectContext) -> Self? {
        return NSEntityDescription
            .insertNewObject(forEntityName: entityName, into: context) as? Self
    }
    
    static func newFetchRequest() -> NSFetchRequest<Self> {
        return .init(entityName: entityName)
    }
    
    static func find(by predicate: NSPredicate, in context: NSManagedObjectContext) -> Self? {
        let request = newFetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    static func find(by attribute: String, value: Any, in context: NSManagedObjectContext) -> Self? {
        let predicate = NSPredicate(format: "%K == %@", attribute, value as! any CVarArg as CVarArg)
        return find(by: predicate, in: context)
    }
}

// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {
    
    func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
    }
    
    func configureAsUpdateContext() {
        undoManager = nil
    }
}

// MARK: - Misc

extension NSSet {
    func toArray<T>(of type: T.Type) -> [T] {
        allObjects.compactMap { $0 as? T }
    }
}
