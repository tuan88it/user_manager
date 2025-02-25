//
//  UserCell.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/24/25.
//

import UIKit
import AppCommon
import SnapKit
import Kingfisher

class UserCell: BaseTableViewCell {
    var viewModel: UserCellViewModel?
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        return view
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = SPACING_SMALL
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = SPACING_SMALL
        return stackView
    }()

    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        view.layer.cornerRadius = SPACING_SMALL
        view.clipsToBounds = true
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 40
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()

    private lazy var separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()

    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .blue
        return label
    }()

    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = SPACING_S_SMALL
        return stackView
    }()

    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mappin.and.ellipse.circle")
        imageView.tintColor = .gray
        return imageView
    }()

    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    override func configurationLayout() {
        applyViewConfiguration()
    }
    override func setViewModel(viewModel: any BaseCellViewModel) {
        self.viewModel = viewModel as? UserCellViewModel
        self.configure()
    }
    func configure() {
        if let user = self.viewModel?.user {
            nameLabel.text = user.login
            urlLabel.text = user.htmlUrl
            if let avatarUrl = user.avatarUrl, let url = URL(string: avatarUrl) {
                avatarImageView.kf.setImage(with: url)
            }
        }
        locationStackView.isHidden = true
        if let userDetail = viewModel?.userDetail {
            nameLabel.text = userDetail.login
            urlLabel.text = userDetail.htmlUrl
            if let avatarUrl = userDetail.avatarUrl, let url = URL(string: avatarUrl) {
                avatarImageView.kf.setImage(with: url)
            }
            if let location = userDetail.location {
                locationLabel.text = userDetail.location
                locationStackView.isHidden = false
            }
            urlLabel.isHidden = true
        }
    }
}

extension UserCell: BaseViewConfiguration {

    func buildHierachy() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(mainStackView)

        mainStackView.addArrangedSubview(avatarContainerView)
        mainStackView.addArrangedSubview(infoStackView)

        avatarContainerView.addSubview(avatarImageView)

        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(separatorLine)
        infoStackView.addArrangedSubview(urlLabel)
        infoStackView.addArrangedSubview(locationStackView)
        infoStackView.addArrangedSubview(UIView())
        
        locationStackView.addArrangedSubview(locationIcon)
        locationStackView.addArrangedSubview(locationLabel)
    }

    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: SPACING, bottom: PADDING12, right: SPACING))
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPACING_MEDIUM, left: SPACING_MEDIUM, bottom: SPACING_MEDIUM, right: SPACING_MEDIUM))
        }
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: SPACING_L_SMALL, left: SPACING_L_SMALL, bottom: SPACING_L_SMALL, right: SPACING_L_SMALL))
        }
        separatorLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        locationIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
    }
    func setupStyles() {
        self.selectionStyle = .none
    }
}
