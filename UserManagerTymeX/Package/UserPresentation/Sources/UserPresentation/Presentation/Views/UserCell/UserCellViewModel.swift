//
//  UserCellViewModel.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/24/25.
//

import Domain
import Foundation
import AppCommon

struct UserCellViewModel: BaseCellViewModel {
    var cellIdentifier: String = "UserCell"
    let user: User?
    let userDetail: UserDetail?
    init(user: User?, userDetail: UserDetail? = nil) {
        self.user = user
        self.userDetail = userDetail
    }
}
