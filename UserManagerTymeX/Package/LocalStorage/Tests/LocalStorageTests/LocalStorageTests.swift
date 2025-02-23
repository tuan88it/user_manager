import XCTest
import RxSwift
import RxTest
import RxBlocking
import Domain

@testable import LocalStorage

final class DefaultUserCoreDataTests: XCTestCase {
    var coreDataStack: CoreDataStack!
    var userCoreData: DefaultUserCoreData!
    let users = [
        User(userId: 1, login: "TuanNguyen", avatarUrl: "", htmlUrl: ""),
        User(userId: 2, login: "ThanhTam", avatarUrl: "", htmlUrl: "")]
    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataStack(version: CoreDataStack.Version.actual)
        userCoreData = DefaultUserCoreData(coreDataStack: coreDataStack)
    }
    
    override func tearDown() {
        userCoreData = nil
        coreDataStack = nil
        super.tearDown()
    }
    
    func testSaveUsers() {
        // Given
        let deleteResult  = try? userCoreData.delete().toBlocking(timeout: 3).first()
        XCTAssertNotNil(deleteResult, "Failed to delete users")
        
        // When
        let result = try? userCoreData.saves(users).toBlocking(timeout: 3).first()
        
        // Then
        XCTAssertNotNil(result)
    }
    
    func testLoadUsers() {
        XCTAssertNotNil(userCoreData, "userCoreData nil")
        // Given
        let deleteResult  = try? userCoreData.delete().toBlocking(timeout: 3).first()
        XCTAssertNotNil(deleteResult, "Failed to delete users")
        let saveResult = try? userCoreData.saves(users).toBlocking(timeout: 3).first()
        XCTAssertNotNil(saveResult, "Failed to save users")
        // When
        let loadedUsers = try? userCoreData.load().toBlocking(timeout: 3).first()
        
        // Then
        XCTAssertEqual(loadedUsers?.count, 2)
        XCTAssertEqual(loadedUsers?.first?.login, "TuanNguyen")
    }
    
    func testDeleteUsers() {
        // Given
        _ = try? userCoreData.saves(users).toBlocking(timeout: 3).first()
        
        // When
        let deleteResult = try? userCoreData.delete().toBlocking(timeout: 3).first()
        let loadedUsers = try? userCoreData.load().toBlocking(timeout: 3).first()
        
        // Then
        XCTAssertNotNil(deleteResult)
        XCTAssertEqual(loadedUsers?.count, 0)
    }
}
