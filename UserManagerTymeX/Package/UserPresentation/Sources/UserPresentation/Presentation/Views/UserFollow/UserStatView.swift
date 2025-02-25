//
//  UserStatView.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import UIKit

class UserStatView: UIView {
    
    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .darkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    init(icon: String, label: String) {
        super.init(frame: .zero)
        iconImageView.image = UIImage(systemName: icon)
        countLabel.text = ""
        descriptionLabel.text = label
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    func update(count: Int) {
        countLabel.text = "\(count)"
    }
    private func setupUI() {
        addSubview(verticalStackView)
        
        // Add subviews to stackView
        let imageContainer = UIView()
        imageContainer.backgroundColor = .gray.withAlphaComponent(0.3)
        imageContainer.layer.cornerRadius = 30
        imageContainer.addSubview(iconImageView)
        
        verticalStackView.addArrangedSubview(imageContainer)
        verticalStackView.addArrangedSubview(countLabel)
        verticalStackView.addArrangedSubview(descriptionLabel)
        
        // Set constraints
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.edges.equalToSuperview().inset(10)
        }
    }
}
