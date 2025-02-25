//
//  CoordinatorAssembly.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/24/25.
//

import DependencyInjection
import UserPresentation
import UIKit

final class CoordinatorAssembly: Assembly {
    func assemble(container: DependencyInjection.Container) {
        container.register(UserCoordinator.self) { _ in
            return UserCoordinator()
        }
        container.register(AppCoordinator?.self) { (_, windows: UIWindow) in
            return AppCoordinator(window: windows)
        }
    }
}
