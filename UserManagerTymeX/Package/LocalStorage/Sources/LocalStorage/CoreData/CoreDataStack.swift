//
//  CoreDataStack.swift
//  LocalStorage
//
//  Created by nguyen minh tuan on 2/19/25.
//

import CoreData
import RxSwift

public protocol PersistentStore {
    typealias DBOperation<Result> = (NSManagedObjectContext) throws -> Result
    
    func inserts<T: NSManagedObject, V>(
        items: [V],
        map: @escaping (V, NSManagedObjectContext) -> T?
    ) -> Observable<[V]>
    func insertsAndUpdates<T: NSManagedObject, V>(
        items: [V],
        fetchsRequest: @escaping (V) -> NSFetchRequest<T>,
        update: @escaping (V, T) -> Void
    ) -> Observable<[V]>
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> Observable<Int>
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
        map: @escaping (T) throws -> V?) -> Observable<[V]>
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> Observable<Result>
    func deleteAllRecords(entityName: String) -> Observable<Void>
}

public class CoreDataStack: PersistentStore {

    public var container: NSPersistentContainer!

    public init(directory: FileManager.SearchPathDirectory = .documentDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        version vNumber: UInt) {
        let version = Version(vNumber)
        let bundle = Bundle.module
        let model = bundle.url(forResource: version.modelName, withExtension: "momd").flatMap { url in
            NSManagedObjectModel(contentsOf: url)
        }

        if let model = model, let url = version.dbFileURL(directory, domainMask) {
            if let container1 = try? NSPersistentContainer.load(name: version.modelName, model: model, url: url) {
                self.container = container1
            }
            let store = NSPersistentStoreDescription(url: url)
            container?.persistentStoreDescriptions = [store]
        } else {
            container = NSPersistentContainer(name: version.modelName)
        }
    }
    public func insertsAndUpdates<T: NSManagedObject, V>(
        items: [V],
        fetchsRequest: @escaping (V) -> NSFetchRequest<T>,
        update: @escaping (V, T) -> Void
    ) -> Observable<[V]> {
        return Observable.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.onCompleted()
                return Disposables.create()
            }
            let backgroundContext = self.container.newBackgroundContext()
            backgroundContext.perform {
                do {
                    for item in items {
                        let fetchRequest = fetchsRequest(item)
                        let existingRecords = try backgroundContext.fetch(fetchRequest)
                        let record: T
                        if let existing = existingRecords.first {
                            record = existing
                        } else {
                            record = T(context: backgroundContext)
                        }
                        update(item, record)
                        if backgroundContext.hasChanges {
                            try backgroundContext.save()
                        }
                    }
                    subscriber.onNext(items)
                    subscriber.onCompleted()
                } catch {
                    subscriber.onError(error)
                }
            }
            return Disposables.create()
        }
    }

    public func inserts<T: NSManagedObject, V>(
        items: [V],
        map: @escaping (V, NSManagedObjectContext) -> T?
    ) -> Observable<[V]> {
        return Observable.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.onCompleted()
                return Disposables.create()
            }

            let backgroundContext = self.container.newBackgroundContext()
            backgroundContext.perform {
                do {
                    for item in items {
                        let object = map(item, backgroundContext)
                    }
                    if backgroundContext.hasChanges {
                        try backgroundContext.save()
                    }
                    subscriber.onNext(items)
                    subscriber.onCompleted()
                } catch {
                    subscriber.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    public func count<T>(_ fetchRequest: NSFetchRequest<T>) -> RxSwift.Observable<Int> where T: NSFetchRequestResult {
        return Observable.create { [weak self] subcriber in
            let backgroundContext = self?.container.newBackgroundContext()
            backgroundContext?.perform({
                do {
                    let count = try backgroundContext?.count(for: fetchRequest)
                    subcriber.onNext(count ?? 0)
                    subcriber.onCompleted()
                } catch {
                    subcriber.onError(error)
                }
                
            })
            return Disposables.create {
            }
        }
    }

    public func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>,
        map: @escaping (T) throws -> V?) -> Observable<[V]> {
        return Observable.create { [weak self] subcriber in
            let backgroundContext = self?.container.newBackgroundContext()
            backgroundContext?.perform {
                do {
                    let managedObjects = try self?.container.viewContext.fetch(fetchRequest)
                    let result: [V] = try managedObjects?.compactMap({ object in
                        let mapped = try map(object)
                        if let mo = object as? NSManagedObject {
                            // Turning object into a fault
                            self?.container.viewContext.refresh(mo, mergeChanges: false)
                        }
                        return mapped
                    }) ?? []
                    subcriber.onNext(result)
                    subcriber.onCompleted()
                } catch {
                    subcriber.onError(error)
                }
            }
            return Disposables.create {

            }
        }
    }

    public func update<Result>(_ operation: @escaping DBOperation<Result>) -> Observable<Result> {
        return Observable.create { [weak self] subcriber in
            let backgroundContext = self?.container.newBackgroundContext()
            backgroundContext?.perform {
                do {
                    let result = try operation(backgroundContext!)
                    if let isChange = backgroundContext?.hasChanges, isChange {
                        try backgroundContext?.save()
                    }
                    subcriber.onNext(result)
                    subcriber.onCompleted()
                } catch {
                    subcriber.onError(error)
                }
                
            }
            return Disposables.create {

            }
        }
    }
    public func deleteAllRecords(entityName: String) -> Observable<Void> {
        return Observable.create { [weak self] subscriber in
            guard let self = self else {
                subscriber.onCompleted()
                return Disposables.create()
            }
            
            let backgroundContext = self.container.newBackgroundContext()
            backgroundContext.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                deleteRequest.resultType = .resultTypeObjectIDs
                
                do {
                    let result = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult
                    if let objectIDs = result?.result as? [NSManagedObjectID] {
                        let changes = [NSDeletedObjectsKey: objectIDs]
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self.container.viewContext])
                    }
                    subscriber.onNext(())
                    subscriber.onCompleted()
                } catch {
                    subscriber.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}

extension NSPersistentContainer {
    static func load(name: String, model: NSManagedObjectModel, url: URL) throws -> NSPersistentContainer {
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw $0 }

        return container
    }
}
