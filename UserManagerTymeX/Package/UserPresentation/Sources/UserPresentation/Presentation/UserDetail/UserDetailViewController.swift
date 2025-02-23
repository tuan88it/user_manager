//
//  UserDetailViewController.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AppCommon

struct UserDetailViewControllerParams {
    let login: String
}
final class UserDetailViewController: BaseViewController {
    private let viewModel: UserDetailViewModelType
    
    private let output: UserDetailViewControllerParams
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .gray
        return control
    }()
    
    
    init(viewModel: UserDetailViewModelType, output: UserDetailViewControllerParams) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func setupUI() {
    }
    override func setupBinding() {
        
    }
}
extension UserDetailViewController {
    
}
