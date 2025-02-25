//
//  UserFollowCell.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import UIKit
import AppCommon
import SnapKit
import Kingfisher

class UserFollowCell: BaseTableViewCell {
    var viewModel: UserFollowCellViewModel?

    private lazy var followersView = {
        UserStatView(icon: "person.2.fill", label: "Follower")
    }()
    private lazy var followingView = {
        UserStatView(icon: "medal.star", label: "Following")
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()

    override func configurationLayout() {
        applyViewConfiguration()
    }

    override func setViewModel(viewModel: BaseCellViewModel) {
        self.viewModel = viewModel as? UserFollowCellViewModel
        self.configure()
    }
    func configure() {
        if let userDetail = viewModel?.userDetail {
            followersView.update(count: userDetail.followers)
            followingView.update(count: userDetail.following)
        }
    }
}

extension UserFollowCell: BaseViewConfiguration {

    func buildHierachy() {
        addSubview(horizontalStackView)

        // Add subviews to stackView
        horizontalStackView.addArrangedSubview(followersView)
        horizontalStackView.addArrangedSubview(followingView)
    }

    func setupConstraints() {
        // Set constraints using SnapKit
        horizontalStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(
                top: SPACING_SMALL,
                left: SPACING_E_LARGE,
                bottom: SPACING_SMALL,
                right: SPACING_E_LARGE
                ))
        }
    }
    func setupStyles() {
        self.selectionStyle = .none
    }
}
