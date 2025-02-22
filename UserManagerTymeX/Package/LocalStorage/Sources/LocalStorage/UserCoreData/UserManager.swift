//
//  UserManager.swift
//  LocalStorage
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Foundation
import RxSwift
import CoreData
import Domain

public protocol UserCoreData {
    func saves(_ users: [User]) -> Observable<Void>
    func load() -> Observable<[User]>
    func update(_ userDetail: UserDetail) -> Observable<Void>
    func delete() -> Observable<Void>
}

public final class DefaultUserCoreData: UserCoreData {
    private let coreDataStack: CoreDataStack

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    public func saves(_ users: [User]) -> Observable<Void> {
        return coreDataStack.inserts(items: users, map: { $0.toLocal($1) })
    }

    public func update(_ userDetail: UserDetail) -> Observable<Void> {
        return coreDataStack.insertsAndUpdates(items: [userDetail]) { user -> NSFetchRequest<CDUser> in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: user.userId))
            fetchRequest.fetchLimit = 1
            return fetchRequest
        } update: { (user: UserDetail, cdUser: CDUser) in
            cdUser.update(user)
        }
    }

    public func load() -> Observable<[User]> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Change `ascending` as needed
        fetchRequest.sortDescriptors = [sortDescriptor]
        return coreDataStack.fetch(fetchRequest) { $0.toUser() }
    }

    //just for future
    public func insertsAndUpdate(_ users: [User]) -> Observable<Void> {
        return coreDataStack.insertsAndUpdates(items: users) { user -> NSFetchRequest<CDUser> in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: user.userId))
            fetchRequest.fetchLimit = 1
            return fetchRequest
        } update: { (user: User, cdUser: CDUser) in
            cdUser.update(user)
        }
    }
    public func delete() -> Observable<Void> {
        return coreDataStack.deleteAllRecords(entityName: CDUser.entityName)
    }
}
