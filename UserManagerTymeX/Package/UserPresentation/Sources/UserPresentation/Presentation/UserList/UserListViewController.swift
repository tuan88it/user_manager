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
import Domain

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

        // Setup TableView
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifierString)
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
            return [SectionModel(model: "Users", items: it)]
        }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx.modelSelected(UserCellViewModel.self).subscribe(onNext: { [weak self] user in
            if let login = user.user?.login {
                self?.output.onShowDetail?(login)
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell.withLatestFrom(viewModel.outputs.isLoading) { ($0, $1) }
            .withUnretained(self)
            .filter { owner, args in
                let ((_, indexPath), isLoading) = args
                guard !isLoading else { return false }
                return owner.tableView.isLastVisibleCell(at: indexPath)
            }
            .debounce(.milliseconds(100), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.viewModel.inputs.loadMore()
            })
            .disposed(by: disposeBag)
    }
}
extension UserListViewController {

}

