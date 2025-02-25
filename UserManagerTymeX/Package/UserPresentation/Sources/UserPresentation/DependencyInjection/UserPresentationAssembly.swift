//
//  UserPresentationAssembly.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//

import DependencyInjection
import Domain
import UIKit

@MainActor
public final class UserPresentationAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: DependencyInjection.Container) {
        //config container for DI
        DIContainer.config(container: container)
        container.register(UserListViewModelType.self) { container in
            guard let useCase = container.resolve(FetchUsersUseCase.self) else {
                fatalError("FetchUsersUseCase dependency could not be resolved")
            }
            return UserListViewModel(useCase: useCase)
        }
        container.register(UserListViewController.self) { (container, output: UserListViewControllerParams) in
            guard let viewModel = container.resolve(UserListViewModelType.self) else {
                fatalError("UserListViewModelType dependency could not be resolved")
            }
            return UserListViewController(viewModel: viewModel, output: output)
        }
        
        container.register(UserDetailViewModelType.self) { (container, login: String) in
            guard let useCase = container.resolve(FetchUserDetailUseCase.self) else {
                fatalError("FetchUserDetailUseCase dependency could not be resolved")
            }
            return UserDetailViewModel(useCase: useCase, login: login)
        }
        container.register(UserDetailViewController.self) { (container, output: UserDetailViewControllerParams) in
            guard let viewModel = container.resolve(UserDetailViewModelType.self, argument: output.login) else {
                fatalError("UserDetailViewModelType dependency could not be resolved")
            }
            return UserDetailViewController(viewModel: viewModel, output: output)
        }
    }
}
