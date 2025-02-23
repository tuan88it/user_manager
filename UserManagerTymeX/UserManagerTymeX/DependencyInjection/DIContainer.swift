//
//  DIContainer.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/23/25.
//

import DependencyInjection
import Foundation
import UserPresentation

@MainActor
final class DIContainer: BaseDIContainer {

    static let shared = DIContainer()
    var container: Container = Container()
    init() {
        let assemblies: [Assembly] = [
            CoordinatorAssembly(),
            DataAssembly(),
            UseCaseAssembly(),
            UserPresentationAssembly()
        ]
        assemblies.forEach { $0.assemble(container: container) }
    }
}
