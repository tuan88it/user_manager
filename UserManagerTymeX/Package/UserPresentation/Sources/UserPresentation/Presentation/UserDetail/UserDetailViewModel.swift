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
    var cellModels: Observable<[BaseCellViewModel]> { get }
}

protocol UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { get }
    var outputs: UserDetailViewModelOutputs { get }
}

final class UserDetailViewModel: BaseViewModel {

    private let useCase: FetchUserDetailUseCase
    private let errorRelay = PublishRelay<Error>()
    private let cellsReplay = BehaviorRelay<[BaseCellViewModel]>.init(value: [])
    private let login: String
    init(useCase: FetchUserDetailUseCase, login: String) {
        self.useCase = useCase
        self.login = login
    }
}

// MARK: - UserDetailViewModel

extension UserDetailViewModel: UserDetailViewModelType {
    var inputs: UserDetailViewModelInputs { self }
    var outputs: UserDetailViewModelOutputs { self }
}

// MARK: - UserDetailViewModelOutputs

extension UserDetailViewModel: UserDetailViewModelOutputs {
    var cellModels: RxSwift.Observable<[any AppCommon.BaseCellViewModel]> { cellsReplay.asObservable() }
    var error: Observable<Error> { errorRelay.asObservable() }
}

// MARK: - UserDetailViewModelInputs

extension UserDetailViewModel: UserDetailViewModelInputs {
    func viewDidLoad() {
        useCase.execute(userName: self.login)
            .trackActivity(self.loading).observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, userDetail in
            let userDetailCell = UserCellViewModel(user: nil, userDetail: userDetail)
            let followCell = UserFollowCellViewModel(userDetail: userDetail)
            let blogCell = UserBlogCellViewModel(userDetail: userDetail)
            let items: [BaseCellViewModel] = [
                userDetailCell,
                followCell,
                blogCell
            ]
            owner.cellsReplay.accept(items)
        }, onError: { owner, error in
            
        }).disposed(by: disposeBag)
    }
}
