//
//  BaseTableViewCell.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/24/25.
//

import UIKit

open class BaseTableViewCell: UITableViewCell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurationLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func configurationLayout() {}
    
    open func setViewModel(viewModel: BaseCellViewModel) {}
}
