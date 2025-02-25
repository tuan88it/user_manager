//
//  UserDetail.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

public struct UserDetail: Equatable {
    public let userId: Int
    public let name: String?
    public let login: String
    public let avatarUrl: String?
    public let htmlUrl: String?
    public let location: String?
    public let followers: Int
    public let following: Int
    public let blog: String?
    public init(userId: Int, name: String?, login: String, avatarUrl: String?, htmlUrl: String?, location: String?, followers: Int, following: Int, blog: String?) {
        self.userId = userId
        self.name = name
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
        self.location = location
        self.followers = followers
        self.following = following
        self.blog = blog
    }
}
