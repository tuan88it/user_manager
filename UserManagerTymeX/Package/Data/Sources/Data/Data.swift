// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import RxSwift
import Infrastructure
import Domain
import LocalStorage

public class Utils {
    public static func checkAPI() {
        let networkClient: NetworkClient<UserRouter> = NetworkClient()
        let request: Single<[UserDTO]> = networkClient.request(.users(since: 0, perPage: 20))
        request.subscribe(onSuccess: { users in
            print(users)
        })
    }
    public static func checkLocalData() {
        let coreDataStack = CoreDataStack(version: CoreDataStack.Version.actual)
        let userManager = DefaultUserCoreData(coreDataStack: coreDataStack)
        let users = [
            User(userId: 1, login: "user3", avatarUrl: "aaaa", htmlUrl: "bbb"),
            User(userId: 2, login: "user4", avatarUrl: "bbb", htmlUrl: "ddd")
        ]
        userManager.delete().subscribe(onNext: {
            userManager.saves(users).subscribe(onNext: { _ in
                userManager.load().subscribe(onNext: { data in
                    print(data)
                })
            })
        })
    }
}
