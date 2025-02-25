//
//  DefaultFetchUserDetailUseCaseTests.swift
//  Domain
//
//  Created by nguyen minh tuan on 2/18/25.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Domain

final class DefaultFetchUserDetailUseCaseTests: XCTestCase {
    private var repository: MockUserRepository!
    private var useCase: DefaultFetchUserDetailUseCase!
    
    override func setUp() {
        super.setUp()
        repository = MockUserRepository()
        useCase = DefaultFetchUserDetailUseCase(repository: repository)
    }
    
    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }
    
    func testExecute_ShouldReturnUserDetail() throws {
        // Given
        let expectedUserDetail = repository.mockUserDetails[1]
        
        // When
        let result = try useCase.execute(userName: "jvantuyl").toBlocking().single()
        
        // Then
        XCTAssertEqual(result, expectedUserDetail)
    }
}
