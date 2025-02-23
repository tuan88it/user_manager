//
//  CDUser.swift
//  LocalStorage
//
//  Created by nguyen minh tuan on 2/19/25.
//

import CoreData
import Domain

extension CDUser: ManagedEntity {}
public extension CDUser {
    func toUser() -> User {
        return User(userId: Int(self.id), login: self.login ?? "", avatarUrl: self.avatarUrl, htmlUrl: self.htmlUrl)
    }
    func toUserDetail() -> UserDetail {
        return UserDetail(userId: Int(self.id), name: self.name, login: self.login ?? "", avatarUrl: self.avatarUrl, htmlUrl: self.htmlUrl, location: self.location, followers: Int(self.followers ?? 0), following: Int(self.following ?? 0))
    }
    func update(_ data: User) {
        self.id = Int16(data.userId)
        self.login = data.login
        self.avatarUrl = data.avatarUrl
        self.htmlUrl = data.htmlUrl
    }
    public convenience init(_ context: NSManagedObjectContext, user: User) {
        self.init(context: context)
        self.id = Int16(user.userId)
        self.avatarUrl = user.avatarUrl
        self.htmlUrl = user.htmlUrl
        self.login = user.login
    }
    func update(_ userDetail: UserDetail) {
        self.id = Int16(userDetail.userId)
        self.name = userDetail.name
        self.login = userDetail.login
        self.avatarUrl = userDetail.avatarUrl
        self.htmlUrl = userDetail.htmlUrl
        self.location = userDetail.location
        self.followers = Int16(userDetail.followers)
        self.following = Int16(userDetail.following)
    }
}
extension User {
    public init(from local: CDUser) {
        self.init(userId: Int(local.id), login: local.login ?? "", avatarUrl: local.avatarUrl, htmlUrl: local.htmlUrl)
    }
    public func toLocal(_ context: NSManagedObjectContext) -> CDUser {
        return CDUser(context, user: self)
    }
}
