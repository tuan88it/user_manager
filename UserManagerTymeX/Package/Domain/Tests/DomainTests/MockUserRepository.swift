//
//  MockUserRepository.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import RxSwift

@testable import Domain

final class MockUserRepository: UserRepository {
    
    
    var mockUsers: [User] = [
        User(
            userId: 101,
            login: "jvantuyl",
            avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4",
            htmlUrl: "https://github.com/jvantuyl"
        ),
        User(
            userId: 102,
            login: "BrianTheCoder",
            avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4",
            htmlUrl: "https://github.com/BrianTheCoder"
        )
    ]
    
    var mockUserDetails: [UserDetail] = [
        UserDetail(
            userId: 0,
            name: "",
            login: "",
            avatarUrl: "",
            htmlUrl: "",
            location: "",
            followers: 0,
            following: 0,
            blog: ""
        ),
        UserDetail(
            userId: 101,
            name: "Jayson Vantuyl",
            login: "jvantuyl",
            avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4",
            htmlUrl: "https://github.com/jvantuyl",
            location: "Plumas County, California, USA",
            followers: 66,
            following: 15,
            blog: ""
        ),
        UserDetail(
            userId: 102,
            name: "Brian Smith",
            login: "BrianTheCoder",
            avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4",
            htmlUrl: "https://github.com/BrianTheCoder",
            location: "Santa Monica,CA",
            followers: 102,
            following: 32,
            blog: ""
        )
    ]
    
    func fetchUsers(offset: Int, perPage: Int) -> Observable<[User]> {
        return Observable.just(mockUsers)
    }
    
    func fetchUserDetail(userName: String) -> Observable<UserDetail> {
        return Observable.just(mockUserDetails.filter { $0.login == userName }.first ?? mockUserDetails[0])
    }
}
