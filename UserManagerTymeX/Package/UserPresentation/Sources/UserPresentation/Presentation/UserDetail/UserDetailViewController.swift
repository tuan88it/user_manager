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
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        return tableView
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
        view.backgroundColor = .white
        title = "User Details"
        
        // Setup TableView
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifierString)
        tableView.register(UserBlogCell.self, forCellReuseIdentifier: UserBlogCell.identifierString)
        tableView.register(UserFollowCell.self, forCellReuseIdentifier: UserFollowCell.identifierString)
        tableView.estimatedRowHeight = 112
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        // Layout using SnapKit
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    override func setupBinding() {
        // RxDataSources configuration
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, BaseCellViewModel>>(
            configureCell: { _, tableView, indexPath, cellViewModel in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath) as! BaseTableViewCell
                cell.setViewModel(viewModel: cellViewModel)
                return cell
            }
        )
        // Bind data to tableView
        viewModel.outputs.cellModels
            .map { it in
                return [SectionModel(model: "UserDetail", items: it)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
extension UserDetailViewController {
    
}
