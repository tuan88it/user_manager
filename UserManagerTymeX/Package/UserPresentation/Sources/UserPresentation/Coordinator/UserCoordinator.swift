//
//  UserCoordinator.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//
//

import AppCommon
import UIKit

@MainActor
public final class UserCoordinator: @preconcurrency NavigationCoordinator {
    public enum UserLink: Link {
        case userList
        case userDetail(login: String)
    }
    
    public lazy var navigationController: UINavigationController = .init()
    public var childCoordinators: [Coordinator] = []
    public var finish: ((Link?) -> Void)?
    
    public init() {}
    
    public func start() {
        navigationController.setViewControllers([makeUserListViewController()], animated: false)
    }
    
    @discardableResult
    public func start(link: Link) -> Bool {
        guard let userLink = link as? UserLink else {
            return childCoordinators.map { $0.start(link: link) }.contains(true)
        }
        
        switch userLink {
            case .userList:
                navigationController.popToRootViewController(animated: true)
                return true
            case let .userDetail(login):
                navigationController.pushViewController(
                    makeUserDetailViewController(login: login),
                    animated: true
                )
                return true
        }
    }
}

private extension UserCoordinator {
    func makeUserListViewController() -> UIViewController {
        let viewControllerParams = UserListViewControllerParams(onShowDetail: {[weak self] login in
            self?.start(link: UserLink.userDetail(login: login))
        })
        let viewController: UserListViewController = DIContainer.shared.resolve(argument: viewControllerParams)
        return viewController
    }
    
    func makeUserDetailViewController(login: String) -> UIViewController {
        let viewControllerParams = UserDetailViewControllerParams(login: login)
        let viewController: UserDetailViewController = DIContainer.shared.resolve(argument: viewControllerParams)
        return viewController
    }
}
