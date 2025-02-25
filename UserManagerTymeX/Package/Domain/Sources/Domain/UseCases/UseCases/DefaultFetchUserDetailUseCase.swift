//
//  DefaultFetchUserDetailUseCase.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import RxSwift

public final class DefaultFetchUserDetailUseCase: FetchUserDetailUseCase {
    private let repository: UserRepository
    
    public init(repository: UserRepository) {
        self.repository = repository
    }
    
    public func execute(userName: String) -> Observable<UserDetail> {
        return repository.fetchUserDetail(userName: userName)
    }
}
