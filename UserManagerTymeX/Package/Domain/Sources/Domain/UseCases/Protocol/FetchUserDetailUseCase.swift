//
//  FetchUserDetailUseCase.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import RxSwift

public protocol FetchUserDetailUseCase {
    func execute(userName: String) -> Observable<UserDetail>
}
