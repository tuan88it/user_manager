//
//  DefaultUserRepositoryTests.swift
//  Data
//
//  Created by nguyen minh tuan on 2/23/25.
//

import XCTest
import RxSwift
import RxBlocking
import Infrastructure

@testable import Data

class DefaultUserRepositoryTests: XCTestCase {
    var repository: DefaultUserRepository!
    var mockNetworkClient: MockNetworkClient<UserRouter>!
    var mockLocalData: MockUserCoreData!
    var mockMapper: MockDataMapper!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient<UserRouter>()
        mockLocalData = MockUserCoreData()
        mockMapper = MockDataMapper()
        
        let dependencies = DefaultRepositoryDependencies(
            networkClient: mockNetworkClient,
            mapper: mockMapper,
            store: mockLocalData
        )
        
        repository = DefaultUserRepository(dependencies: dependencies)
    }
    
    func testFetchUsers_WhenNetworkHasData_ShouldSaveToLocalAndReturn() throws {
        // Given
        let mockUsers = mockNetworkClient.mockUsers
        
        // When
        let users = try repository.fetchUsers(offset: 0, perPage: 2).toBlocking(timeout: 3).first()
        
        // Then
        XCTAssertEqual(users?.count, 2)
        XCTAssertEqual(users?.first?.login, "jvantuyl")
        XCTAssertEqual(mockLocalData.savedUsers.count, 2)
    }
    
    func testFetchUserDetail_WhenNetworkHasData_ShouldSaveToLocalAndReturn() throws {
        // Given
        let mockUserDetail = mockNetworkClient.mockUserDetail
        
        // When
        let userDetail = try repository.fetchUserDetail(userName: "TuanNguyen").toBlocking(timeout: 3).first()
        
        // Then
        XCTAssertEqual(userDetail?.login, "jvantuyl")
        XCTAssertNotNil(mockLocalData.savedUserDetail)
    }
}
