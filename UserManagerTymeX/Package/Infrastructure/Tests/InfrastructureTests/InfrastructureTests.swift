//
//  InfrastructureTests.swift
//  Infrastructure
//
//  Created by nguyen minh tuan on 2/19/25.
//


import XCTest
import RxSwift
import RxTest
import RxBlocking
import Alamofire

@testable import Infrastructure

final class InfrastructureTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRequest_ShouldReturnUserList() throws {
        // Given
        let mockData = """
        [
        {
        "login": "jvantuyl",
        "id": 101,
        "node_id": "MDQ6VXNlcjEwMQ==",
        "avatar_url": "https://avatars.githubusercontent.com/u/101?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/jvantuyl",
        "html_url": "https://github.com/jvantuyl",
        "followers_url": "https://api.github.com/users/jvantuyl/followers",
        "following_url": "https://api.github.com/users/jvantuyl/following{/other_user}",
        "gists_url": "https://api.github.com/users/jvantuyl/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/jvantuyl/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/jvantuyl/subscriptions",
        "organizations_url": "https://api.github.com/users/jvantuyl/orgs",
        "repos_url": "https://api.github.com/users/jvantuyl/repos",
        "events_url": "https://api.github.com/users/jvantuyl/events{/privacy}",
        "received_events_url": "https://api.github.com/users/jvantuyl/received_events",
        "type": "User",
        "user_view_type": "public",
        "site_admin": false
        },
        {
        "login": "BrianTheCoder",
        "id": 102,
        "node_id": "MDQ6VXNlcjEwMg==",
        "avatar_url": "https://avatars.githubusercontent.com/u/102?v=4",
        "gravatar_id": "",
        "url": "https://api.github.com/users/BrianTheCoder",
        "html_url": "https://github.com/BrianTheCoder",
        "followers_url": "https://api.github.com/users/BrianTheCoder/followers",
        "following_url": "https://api.github.com/users/BrianTheCoder/following{/other_user}",
        "gists_url": "https://api.github.com/users/BrianTheCoder/gists{/gist_id}",
        "starred_url": "https://api.github.com/users/BrianTheCoder/starred{/owner}{/repo}",
        "subscriptions_url": "https://api.github.com/users/BrianTheCoder/subscriptions",
        "organizations_url": "https://api.github.com/users/BrianTheCoder/orgs",
        "repos_url": "https://api.github.com/users/BrianTheCoder/repos",
        "events_url": "https://api.github.com/users/BrianTheCoder/events{/privacy}",
        "received_events_url": "https://api.github.com/users/BrianTheCoder/received_events",
        "type": "User",
        "user_view_type": "public",
        "site_admin": false
        }
        ]
        """.data(using: .utf8)!
        let expectedUsers = [
            MockUserDTO(login: "jvantuyl", id: 101, avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", url: "https://api.github.com/users/jvantuyl", htmlUrl: "https://github.com/jvantuyl"),
            MockUserDTO(login: "BrianTheCoder", id: 102, avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4", url: "https://api.github.com/users/BrianTheCoder", htmlUrl: "https://github.com/BrianTheCoder")
        ]
        let mockClient: MockNetworkClient<MockUserRouter> = MockNetworkClient(mockResult: .success(mockData))
        
        // When
        let request: Single<[MockUserDTO]> = mockClient.request(.users(since: 0, perPage: 0))
        let result = try request.toBlocking().single().map({$0})
        
        // Then
        XCTAssertEqual(result.count, expectedUsers.count)
        XCTAssertEqual(result[0].id, expectedUsers[0].id)
        XCTAssertEqual(result[1].id, expectedUsers[1].id)
    }
}
