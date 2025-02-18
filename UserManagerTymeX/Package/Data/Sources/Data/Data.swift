// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import RxSwift
import Infrastructure
import Domain

public class Utils {
    public static func sayHello() {
        let networkClient: NetworkClient<UserRouter> = NetworkClient()
        let request: Single<[UserDTO]> = networkClient.request(.users(since: 0, perPage: 10))
        request.subscribe(onSuccess: { users in
            print(users)
        })
    }
}
