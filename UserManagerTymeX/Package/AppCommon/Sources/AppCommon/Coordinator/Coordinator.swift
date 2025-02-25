//
//  Coordinator.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit

public protocol Link {}

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var finish: ((Link?) -> Void)? { get set }
    
    func start()
    func start(link: Link) -> Bool
    
}

public protocol NavigationCoordinator: Coordinator {
    var navigationController: UINavigationController { get set }
}
