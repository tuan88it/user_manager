//
//  UserRepository.swift
//  Data
//
//  Created by nguyen minh tuan on 2/22/25.
//

import RxSwift
import Domain
import LocalStorage
import Infrastructure

public protocol RepositoryDependencies {
    var networkClient: NetworkClient<UserRouter> { get }
    var mapper: DataMapper { get }
    var localData: UserCoreData { get }
}
public struct DefaultRepositoryDependencies: RepositoryDependencies {
    public let networkClient: NetworkClient<UserRouter>
    public let mapper: DataMapper
    public let localData: UserCoreData
    public init(
        networkClient: NetworkClient<UserRouter>,
        mapper: DataMapper,
        store: UserCoreData
    ) {
        self.networkClient = networkClient
        self.mapper = mapper
        self.localData = store
    }
}
public final class DefaultUserRepository: UserRepository {

    private let dependencies: RepositoryDependencies

    public init(dependencies: RepositoryDependencies) {
        self.dependencies = dependencies
    }

    public func fetchUsers(offset: Int, perPage: Int) -> RxSwift.Observable<[Domain.User]> {
        let request: Observable<[UserDTO]> = dependencies.networkClient.request(.users(offset: offset, perPage: perPage))
            .asObservable()
            .share()

        let networkRequest: Observable<[User]> = request.map { [weak self] datas in
            guard let self = self else { return [] }
            return datas.map(self.dependencies.mapper.map)
        }
        let requestAndStore = networkRequest.flatMapLatest { [weak self] users in
            guard let self = self else { return Observable.just(users) }
            return self.dependencies.localData.saves(users)
        }

        let localRequest = dependencies.localData.load(perPage: perPage).share()

        if offset == 0 {
            return Observable.concat([
                localRequest,
                Observable.combineLatest(localRequest, requestAndStore).map({ (local, network) in
                    return network.filter { user in
                        return !local.contains { it in
                            it.login == user.login
                        }
                    }
                })
                ])
        }
        return requestAndStore
    }

    public func fetchUserDetail(userName: String) -> RxSwift.Observable<Domain.UserDetail> {
        let localRequest = dependencies.localData.loadUserDetail(userName: userName)
        let request: Observable<UserDetailDTO> = dependencies.networkClient.request(.userDetail(userName: userName)).asObservable().share()
        let networkRequest: Observable<UserDetail> = request.flatMapLatest { [weak self] userDTO -> Observable<UserDetail> in
            guard let self = self else { return Observable.empty() }
            return self.dependencies.localData.save(self.dependencies.mapper.map(userDTO))
        }
        return Observable.concat([localRequest, networkRequest])
    }
}
