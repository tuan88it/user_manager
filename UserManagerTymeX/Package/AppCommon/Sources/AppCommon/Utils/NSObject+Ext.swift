//
//  NSObject+Ext.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/23/25.
//

import UIKit

// MARK: - Response Identifier
protocol ResponseIdentifier { }

extension ResponseIdentifier {
    var identifierString: String {
        return String(describing: type(of: self))
    }
    
    static var identifierString: String {
        return String(describing: self)
    }
}

extension NSObject: ResponseIdentifier { }

extension NSObject {
    
}
