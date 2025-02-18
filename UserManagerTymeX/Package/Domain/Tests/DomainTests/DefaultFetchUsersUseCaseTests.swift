//
//  DefaultFetchUsersUseCaseTests.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Domain

final class DefaultFetchUsersUseCaseTests: XCTestCase {
    private var repository: MockUserRepository!
    private var useCase: DefaultFetchUsersUseCase!
    
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        useCase = DefaultFetchUsersUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_ShouldReturnUsers() throws {
        // Given
        let expectedUsers = repository.mockUsers
        
        // When
        let result = try useCase.execute(since: 0, perPage: 10).toBlocking().single()
        
        // Then
        XCTAssertEqual(result, expectedUsers)
    }
}
