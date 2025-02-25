//
//  View+Ext.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/25/25.
//

import UIKit

extension UIView {
    public static func bundle() -> Bundle {
        return Bundle(for: self.classForCoder())
    }
    public var identifierString: String {
        return String(describing: type(of: self))
    }
    
    public static var identifierString: String {
        return String(describing: self)
    }
}
