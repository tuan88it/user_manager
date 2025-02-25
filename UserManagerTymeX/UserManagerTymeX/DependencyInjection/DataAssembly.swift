//
//  DataAssembly.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/23/25.
//

import DependencyInjection
import Data
import Infrastructure
import LocalStorage
import Domain

final class DataAssembly: Assembly {
    func assemble(container: DependencyInjection.Container) {
        container.register(NetworkClient<UserRouter>.self) { _ in
            NetworkClient<UserRouter>()
        }
        container.register(DataMapper.self) { _ in
            DefaultDataMapper()
        }
        container.register(CoreDataStack.self) { _ in
            CoreDataStack(version: CoreDataStack.Version.actual)
        }
        container.register(UserCoreData.self) { container in
            guard let coreDataStack = container.resolve(CoreDataStack.self) else {
                fatalError("CoreDataStack dependency could not be resolved")
            }
            return DefaultUserCoreData(coreDataStack: coreDataStack)
        }
        container.register(RepositoryDependencies.self) { container in
            guard let networkClient = container.resolve(NetworkClient<UserRouter>.self) else {
                fatalError("NetworkClient<UserRouter> dependency could not be resolved")
            }
            guard let mapper = container.resolve(DataMapper.self) else {
                fatalError("DataMapper dependency could not be resolved")
            }
            guard let userCoreData = container.resolve(UserCoreData.self) else {
                fatalError("UserCoreData dependency could not be resolved")
            }
            return DefaultRepositoryDependencies(networkClient: networkClient, mapper: mapper, store: userCoreData)
        }
        container.register(UserRepository.self) { container in
            guard let dependencies = container.resolve(RepositoryDependencies.self) else {
                fatalError("RepositoryDependencies dependency could not be resolved")
            }
            return DefaultUserRepository(dependencies: dependencies)
        }
    }
}
