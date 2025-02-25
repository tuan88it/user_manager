//
//  DIContainer.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/24/25.
//

import DependencyInjection
import UIKit

@MainActor
final class DIContainer: BaseDIContainer {
    static let shared = DIContainer()
    public var container: Container = Container()
    private static var isConfig: Bool?
    public static func config(container: Container) {
        isConfig = true
        DIContainer.shared.container = container
    }
    init() {
        guard let isConfig = DIContainer.isConfig else {
            fatalError("Error - you must call setup before accessing BRPresentation.DIContainer.shared")
        }
    }
}
