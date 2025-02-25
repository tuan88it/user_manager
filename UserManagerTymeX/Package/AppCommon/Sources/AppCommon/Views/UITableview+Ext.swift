//
//  UITableview+Ext.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/25/25.
//

import UIKit

public extension UITableView {
    public func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = lastIndexPath else { return false }
        return indexPath == lastIndexPath
    }
    
    private var lastIndexPath: IndexPath? {
        let section = numberOfSections - 1
        guard section >= 0 else { return nil }
        let item = numberOfRows(inSection: section) - 1
        guard item >= 0 else { return nil }
        
        return IndexPath(item: item, section: section)
    }
}
