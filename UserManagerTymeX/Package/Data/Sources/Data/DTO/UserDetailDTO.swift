//
//  UserDetailDTO.swift
//  Data
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Foundation

public struct UserDetailDTO: Codable {
    let login: String
    let id: Int
    let avatarUrl, url, htmlUrl: String?
    let name: String?
    let blog: String?
    let location: String?
    let followers, following: Int?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarUrl = "avatar_url"
        case url
        case htmlUrl = "html_url"
        case name, blog, location, followers, following
    }
}
