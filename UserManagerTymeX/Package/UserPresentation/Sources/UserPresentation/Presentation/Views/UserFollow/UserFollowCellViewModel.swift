//
//  UserFollowCellViewModel.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import Domain
import Foundation
import AppCommon

struct UserFollowCellViewModel: BaseCellViewModel {
    var cellIdentifier: String = "UserFollowCell"
    let userDetail: UserDetail
    init(userDetail: UserDetail) {
        self.userDetail = userDetail
    }
}
