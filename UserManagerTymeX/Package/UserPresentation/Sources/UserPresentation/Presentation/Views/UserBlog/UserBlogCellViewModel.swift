//
//  UserBlogCellViewModel.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import Domain
import Foundation
import AppCommon

struct UserBlogCellViewModel: BaseCellViewModel {
    var cellIdentifier: String = "UserBlogCell"
    let userDetail: UserDetail
    init(userDetail: UserDetail) {
        self.userDetail = userDetail
    }
}
