//
//  UsersRepositoryProtocol.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import Foundation
import RxSwift

public protocol UserRepository {
    func fetchUsers(since: Int, perPage: Int) -> Observable<[User]>
    func fetchUserDetail(userName: String) -> Single<UserDetail>
}
