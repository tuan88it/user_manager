import Testing
import XCTest
import RxSwift
import RxTest
import RxBlocking
import Domain
import AppCommon

@testable import UserPresentation

extension XCTestCase {
    @MainActor
    func checkForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

// MARK: - Mocks FetchUsersUseCaseMock
class FetchUsersUseCaseMock: FetchUsersUseCase {
    var mockResult: Observable<[User]> = .just([])
    func execute(offset: Int, perPage: Int) -> RxSwift.Observable<[Domain.User]> {
        return mockResult
    }
}

// MARK: - Mock MockFetchUserDetailUseCase
final class MockFetchUserDetailUseCase: FetchUserDetailUseCase {
    var mockResult: Observable<UserDetail> = .empty()
    
    func execute(userName: String) -> Observable<UserDetail> {
        return mockResult
    }
}
