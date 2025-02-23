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
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var avatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
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
        view.backgroundColor = .lightGray
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
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var locationIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location")
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
    
    func setViewModel(viewModel: UserCellViewModel) {
        self.viewModel = viewModel
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
        
        if let userDetail = viewModel?.userDetail {
            locationLabel.text = userDetail.location
            locationLabel.isHidden = false
        }else {
            locationLabel.isHidden = true
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
    }
    
    func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 4, right: 16))
        }
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        avatarContainerView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
        }
        avatarImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }
}
