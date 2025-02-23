//
//  DataMapper.swift
//  Data
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Domain

public protocol DataMapper {
    func map(_ dto: UserDTO) -> User
    func map(_ dto: UserDetailDTO) -> UserDetail
}

public final class DefaultDataMapper: DataMapper {
    public init() {}
    
    public func map(_ dto: UserDTO) -> User {
        return User(
            userId: dto.id,
            login: dto.login,
            avatarUrl: dto.avatarUrl,
            htmlUrl: dto.htmlUrl
        )
    }
    
    public func map(_ dto: UserDetailDTO) -> UserDetail {
        return UserDetail(
            userId: dto.id,
            name: dto.name,
            login: dto.login,
            avatarUrl: dto.avatarUrl,
            htmlUrl: dto.htmlUrl,
            location: dto.location,
            followers: dto.followers ?? 0,
            following: dto.following ?? 0
        )
    }
}
