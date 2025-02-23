//
//  UserDetailViewModel.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//

import RxSwift
import RxCocoa
import Domain
import AppCommon

// MARK: - Protocols

protocol UserDetailViewModelInputs {
    func viewDidLoad()
}

protocol UserDetailViewModelOutputs {
    var error: Observable<Error> { get }
}

protocol UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { get }
    var outputs: UserDetailViewModelOutputs { get }
}

final class UserDetailViewModel: BaseViewModel {

    private let useCase: FetchUserDetailUseCase
    private let errorRelay = PublishRelay<Error>()

    init(useCase: FetchUserDetailUseCase) {
        self.useCase = useCase
    }
}

// MARK: - UserDetailViewModel

extension UserDetailViewModel: UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { self }
    var outputs: UserDetailViewModelOutputs { self }
}

// MARK: - UserDetailViewModelOutputs

extension UserDetailViewModel: UserDetailViewModelOutputs {
    var error: Observable<Error> { errorRelay.asObservable() }
}

// MARK: - UserDetailViewModelInputs

extension UserDetailViewModel: UserDetailViewModelInputs {
    func viewDidLoad() {

    }

}
