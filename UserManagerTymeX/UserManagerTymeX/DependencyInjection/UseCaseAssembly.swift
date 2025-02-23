//
//  UseCaseAssembly.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/23/25.
//

import DependencyInjection
import Data
import Infrastructure
import LocalStorage
import Domain

final class UseCaseAssembly: Assembly {
    func assemble(container: DependencyInjection.Container) {
        container.register(FetchUsersUseCase.self) { container in
            guard let repository = container.resolve(UserRepository.self) else {
                fatalError("UserRepository dependency could not be resolved")
            }
            return DefaultFetchUsersUseCase(repository: repository)
        }
        container.register(FetchUserDetailUseCase.self) { container in
            guard let repository = container.resolve(UserRepository.self) else {
                fatalError("UserRepository dependency could not be resolved")
            }
            return DefaultFetchUserDetailUseCase(repository: repository)
        }
    }
}
