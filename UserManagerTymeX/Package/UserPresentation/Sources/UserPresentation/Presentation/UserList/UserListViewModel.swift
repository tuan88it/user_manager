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

// MARK: - Protocols

protocol UserListViewModelInputs {
    func viewDidLoad()
    func refresh()
    func reload()
    func load(offset: Int, perPage: Int)
}

protocol UserListViewModelOutputs {
    var error: Observable<Error> { get }
}

protocol UserListViewModelType {
    var inputs: UserListViewModelInputs { get }
    var outputs: UserListViewModelOutputs { get }
}

final class UserListViewModel: BaseViewModel {
    
    private let useCase: FetchUsersUseCase
    private let errorRelay = PublishRelay<Error>()
    
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
    var error: Observable<Error> { errorRelay.asObservable() }
}

// MARK: - UserListViewModelInputs

extension UserListViewModel: UserListViewModelInputs {
    func viewDidLoad() {
        useCase.execute(offset: 0, perPage: 20).subscribe(onNext: { [weak self] users in
            guard let self = self else { return }
            print(users)
        }).disposed(by: disposeBag)
    }
    
    func refresh() {
        
    }
    
    func reload() {
        
    }
    func load(offset: Int, perPage: Int) {
        
    }
    
}
