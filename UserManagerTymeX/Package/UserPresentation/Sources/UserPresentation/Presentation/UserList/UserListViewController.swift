//
//  UserListViewController.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AppCommon
import SnapKit

struct UserListViewControllerParams {
    let onShowDetail: ((String) -> Void)?
}
final class UserListViewController: BaseViewController {
    private let viewModel: UserListViewModelType
    private let output: UserListViewControllerParams
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .gray
        return control
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
    }()
    
    init(viewModel: UserListViewModelType, output: UserListViewControllerParams) {
        self.viewModel = viewModel
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        title = "Github Users"
        // Setup UISearchController
        // Setup TableView
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        // Layout using SnapKit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func setupBinding() {
        
    }
}
extension UserListViewController {
    
}
