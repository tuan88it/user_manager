//
//  AppCoordinator.swift
//  UserManagerTymeX
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit
import AppCommon

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var finish: ((Link?) -> Void)?
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setupNavigationStyle()
        window.makeKeyAndVisible()
        childCoordinators.first?.start()
    }
    
    private func setupNavigationStyle() {
        guard let navigationCoordinator = childCoordinators.first as? NavigationCoordinator else {
            fatalError("No NavigationCoordinator found for initial screen")
        }
        
        let sharedNavigationController = navigationCoordinator.navigationController
        window.rootViewController = sharedNavigationController
        
        for coordinator in childCoordinators {
            (coordinator as? NavigationCoordinator)?.navigationController = sharedNavigationController
            setupFinishHandler(for: coordinator)
        }
    }
    
    private func setupFinishHandler(for coordinator: Coordinator) {
        coordinator.finish = { [weak self] deepLink in
            if let deepLink = deepLink {
                _ = self?.start(link: deepLink)
            }
        }
    }
    
    func start(link: Link) -> Bool {
        return childCoordinators.map { $0.start(link: link) }.contains(true)
    }
}

extension AppCoordinator {
    struct Configuration {
        enum PresentationStyle {
            case tabBar, navigation
        }
        
        var style: PresentationStyle
        
        init(style: PresentationStyle) {
            self.style = style
        }
    }
}

extension AppCoordinator.Configuration {
    static var userConfiguration: Self {
        .init(style: .navigation)
    }
}
