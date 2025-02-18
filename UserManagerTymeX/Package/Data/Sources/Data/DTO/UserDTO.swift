//
//  UserDTO.swift
//  Data
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Foundation

public struct UserDTO: Codable {
    public let login: String
    public let id: Int
    public let avatarUrl, url, htmlUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarUrl = "avatar_url"
        case url = "url"
        case htmlUrl = "html_url"
    }
}
