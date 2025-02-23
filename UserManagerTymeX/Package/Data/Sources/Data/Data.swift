// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import RxSwift
import Infrastructure
import Domain
import LocalStorage

public class Utils {
    nonisolated(unsafe) public static let shared = Utils()
    let repo = DefaultUserRepository(
        dependencies: DefaultRepositoryDependencies(
            networkClient: NetworkClient<UserRouter>(),
            mapper: DefaultDataMapper(),
            store: DefaultUserCoreData(coreDataStack: CoreDataStack(version: CoreDataStack.Version.actual))))
    public init() {

    }
    public static func checkAPI() {
        let networkClient: NetworkClient<UserRouter> = NetworkClient()
        let request: Single<[UserDTO]> = networkClient.request(.users(offset: 0, perPage: 20))
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
    public static func checkRepo() {

        Utils.shared.repo.fetchUsers(offset: 0, perPage: 20).subscribe(onNext: { data in
            print(data)
        })
        Utils.shared.repo.fetchUserDetail(userName: "mojombo").subscribe(onNext: { userDetail in
            print(userDetail)
        })
    }
}
