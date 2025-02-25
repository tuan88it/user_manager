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
    func saves(_ users: [User]) -> Observable<[User]>
    func load(perPage: Int) -> Observable<[User]>
    func load() -> Observable<[User]>
    func update(_ userDetail: UserDetail) -> Observable<[UserDetail]>
    func delete() -> Observable<Void>
    func loadUserDetail(userName: String) -> Observable<UserDetail>
    func save(_ userDetail: UserDetail) -> Observable<UserDetail>
}

public final class DefaultUserCoreData: UserCoreData {
    private let coreDataStack: CoreDataStack

    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    public func saves(_ users: [User]) -> Observable<[User]> {
        return coreDataStack.insertsAndUpdates(items: users) { user -> NSFetchRequest<CDUser> in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: user.userId))
            fetchRequest.fetchLimit = 1
            return fetchRequest
        } update: { (user: User, cdUser: CDUser) in
            cdUser.update(user)
        }
    }
    public func save(_ userDetail: UserDetail) -> Observable<UserDetail> {
        return coreDataStack.insertsAndUpdates(items: [userDetail]) { user in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: user.userId))
            fetchRequest.fetchLimit = 1
            return fetchRequest
        } update: { (user: UserDetail, cdUser: CDUser) in
            cdUser.update(user)
        }.compactMap({ $0.first })
    }
    public func update(_ userDetail: UserDetail) -> Observable<[UserDetail]> {
        return coreDataStack.insertsAndUpdates(items: [userDetail]) { user -> NSFetchRequest<CDUser> in
            let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: user.userId))
            fetchRequest.fetchLimit = 1
            return fetchRequest
        } update: { (user: UserDetail, cdUser: CDUser) in
            cdUser.update(user)
        }
    }

    public func load(perPage: Int) -> Observable<[User]> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.fetchLimit = perPage
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Change `ascending` as needed
        fetchRequest.sortDescriptors = [sortDescriptor]
        return coreDataStack.fetch(fetchRequest) { $0.toUser() }
    }
    public func load() -> Observable<[User]> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true) // Change `ascending` as needed
        fetchRequest.sortDescriptors = [sortDescriptor]
        return coreDataStack.fetch(fetchRequest) { $0.toUser() }
    }

    //just for future
    public func insertsAndUpdate(_ users: [User]) -> Observable<[User]> {
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
    public func loadUserDetail(userName: String) -> Observable<UserDetail> {
        let fetchRequest: NSFetchRequest<CDUser> = CDUser.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "login == %@", userName)
        return coreDataStack.fetch(fetchRequest) { $0.toUserDetail() }.compactMap { $0.first }
    }
}
