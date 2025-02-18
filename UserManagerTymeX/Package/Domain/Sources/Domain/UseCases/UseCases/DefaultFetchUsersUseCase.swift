//
//  DefaultFetchUsersUseCase.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import RxSwift

public final class DefaultFetchUsersUseCase: FetchUsersUseCase {
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func execute(since: Int, perPage: Int) -> Observable<[User]> {
        return repository.fetchUsers(since: since, perPage: perPage)
    }
}
