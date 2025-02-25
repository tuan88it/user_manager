//
//  FetchUsersUseCase.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import RxSwift

public protocol FetchUsersUseCase {
    func execute(offset: Int, perPage: Int) -> Observable<[User]>
}
