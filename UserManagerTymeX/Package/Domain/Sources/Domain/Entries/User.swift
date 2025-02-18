//
//  User.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import Foundation

public struct User: Equatable {
    public let userId: Int
    public let login: String
    public let avatarUrl: String?
    public let htmlUrl: String?
    
    public init(userId: Int, login: String, avatarUrl: String?, htmlUrl: String?) {
        self.userId = userId
        self.login = login
        self.avatarUrl = avatarUrl
        self.htmlUrl = htmlUrl
    }
}
