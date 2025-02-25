//
//  UserBlogCell.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import UIKit
import AppCommon
import SnapKit
import Kingfisher

class UserBlogCell: BaseTableViewCell {
    var viewModel: UserBlogCellViewModel?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = SPACING_SMALL
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.text = "Blog"
        return label
    }()
    
    private lazy var blogLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override func configurationLayout() {
        applyViewConfiguration()
    }
    
    override func setViewModel(viewModel: BaseCellViewModel) {
        self.viewModel = viewModel as? UserBlogCellViewModel
        self.configure()
    }
    func configure() {
        if let blog = viewModel?.userDetail.blog {
            blogLabel.text = blog
        }
    }
}

extension UserBlogCell: BaseViewConfiguration {
    
    func buildHierachy() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(blogLabel)
    }
    
    func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(SPACING)
        }
    }
    func setupStyles() {
        self.selectionStyle = .none
    }
}
