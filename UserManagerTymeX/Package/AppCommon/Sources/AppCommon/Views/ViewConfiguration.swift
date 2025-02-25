//
//  ViewConfiguration.swift
//  AppCommon
//
//  Created by nguyen minh tuan on 2/24/25.
//

import UIKit

@MainActor
public protocol BaseViewConfiguration {
    func buildHierachy()
    func setupConstraints()
    func setupStyles()
}
@MainActor
extension BaseViewConfiguration {
    public func applyViewConfiguration() {
        buildHierachy()
        setupConstraints()
        setupStyles()
    }
    
    public func setupStyles() {}
}
