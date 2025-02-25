//
//  UserListViewModel.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//

import RxSwift
import RxCocoa
import Domain
import AppCommon
import UIKit

// MARK: - Protocols

protocol UserListViewModelInputs {
    func viewDidLoad()
    func refresh()
    func reload()
    func load(offset: Int, perPage: Int)
    func loadMore()
}

protocol UserListViewModelOutputs {
    var error: Observable<Error> { get }
    var cellModels: Observable<[BaseCellViewModel]> { get }
    var isLoading: Observable<Bool> { get }
}

protocol UserListViewModelType {
    var inputs: UserListViewModelInputs { get }
    var outputs: UserListViewModelOutputs { get }
}

final class UserListViewModel: BaseViewModel {

    private let useCase: FetchUsersUseCase
    private let errorRelay = PublishRelay<Error>()
    private let userReplay = BehaviorRelay<[BaseCellViewModel]>.init(value: [])
    private var currentPage = 0

    init(useCase: FetchUsersUseCase) {
        self.useCase = useCase
    }
}

// MARK: - UserListViewModelType

extension UserListViewModel: UserListViewModelType {
    var inputs: UserListViewModelInputs { self }
    var outputs: UserListViewModelOutputs { self }
}

// MARK: - UserListViewModelOutputs

extension UserListViewModel: UserListViewModelOutputs {
    var isLoading: Observable<Bool> { showLoading }
    var error: Observable<Error> { errorRelay.asObservable() }
    var cellModels: Observable<[BaseCellViewModel]> { userReplay.asObservable() }
}

// MARK: - UserListViewModelInputs

extension UserListViewModel: UserListViewModelInputs {
    func viewDidLoad() {
        loadUsers()
    }

    func refresh() {

    }

    func reload() {

    }
    func load(offset: Int, perPage: Int) {

    }
    func loadMore() {
        loadUsers()
    }
}
private extension UserListViewModel {
    func loadUsers() {
        let offset = currentPage * Constants.perPage
        useCase.execute(offset: offset, perPage: Constants.perPage)
            .trackActivity(self.loading).observe(on: MainScheduler.instance)
            .subscribe(with: self, onNext: { owner, users in
            var oldCellsItems = owner.userReplay.value
            users.forEach { user in
                oldCellsItems.append(UserCellViewModel(user: user, userDetail: nil))
            }
            owner.userReplay.accept(oldCellsItems)
            if offset == 0 {
                owner.currentPage = 1
            } else {
                owner.currentPage += 1
            }
        }, onError: { owner, error in
                owner.errorRelay.accept(error)
            }).disposed(by: disposeBag)
    }
}
