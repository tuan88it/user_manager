//
//  UserListViewModelTests.swift
//  UserPresentation
//
//  Created by nguyen minh tuan on 2/25/25.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
import Domain
import AppCommon
@testable import UserPresentation

class UserListViewModelTests: XCTestCase {
    
    private var viewModel: UserListViewModel!
    private var useCaseMock: FetchUsersUseCaseMock!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        useCaseMock = FetchUsersUseCaseMock()
        viewModel = UserListViewModel(useCase: useCaseMock)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        useCaseMock = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func test_viewDidLoad_fetchesUsers() {
        // Arrange
        let users = [
            User(userId: 101, login: "jvantuyl", avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", htmlUrl: "https://github.com/jvantuyl"),
            User(userId: 102, login: "BrianTheCoder", avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4", htmlUrl: "https://github.com/BrianTheCoder")
        ]
        useCaseMock.mockResult = .just(users)
        
        let observer = scheduler.createObserver([BaseCellViewModel].self)
        viewModel.outputs.cellModels.bind(to: observer).disposed(by: disposeBag)
        
        // Act
        viewModel.inputs.viewDidLoad()
        scheduler.start()
        
        // Assert
        let expectedCells = users.map { UserCellViewModel(user: $0, userDetail: nil) }
        XCTAssertEqual(observer.events.last?.value.element?.count, expectedCells.count)
    }
    
    func test_loadMore_incrementsPageAndFetchesMoreUsers() {
        // Arrange
        let initialUsers = [User(userId: 101, login: "jvantuyl", avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", htmlUrl: "https://github.com/jvantuyl")]
        let additionalUsers = [User(userId: 102, login: "BrianTheCoder", avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4", htmlUrl: "https://github.com/BrianTheCoder")]
        
        useCaseMock.mockResult = .just(initialUsers)
        viewModel.inputs.viewDidLoad()
        
        useCaseMock.mockResult = .just(additionalUsers)
        
        let observer = scheduler.createObserver([BaseCellViewModel].self)
        viewModel.outputs.cellModels.bind(to: observer).disposed(by: disposeBag)
        
        // Act
        viewModel.inputs.loadMore()
        scheduler.start()
        
        // Assert
        let expectedCells = (initialUsers + additionalUsers).map { UserCellViewModel(user: $0, userDetail: nil) }
        XCTAssertEqual(observer.events.last?.value.element?.count, expectedCells.count)
    }
    
    func test_errorIsPublishedOnFailure() {
        // Arrange
        let testError = NSError(domain: "TestError", code: 0, userInfo: nil)
        useCaseMock.mockResult = .error(testError)
        
        let observer = scheduler.createObserver(Error.self)
        viewModel.outputs.error.bind(to: observer).disposed(by: disposeBag)
        
        // Act
        viewModel.inputs.viewDidLoad()
        scheduler.start()
        
        // Assert
        XCTAssertEqual(observer.events.count, 1)
    }
    @MainActor
    func test_usersListViewModel_doesNotCreateMemoryLeak() {
        let sut = UserListViewModel(useCase: useCaseMock)
        checkForMemoryLeak(sut)
    }
    
    @MainActor
    func test_usersListViewController_doesNotCreateMemoryLeak() {
        let viewModel = UserListViewModel(useCase: useCaseMock)
        let sut = UserListViewController(viewModel: viewModel, output: UserListViewControllerParams(onShowDetail: nil))
        checkForMemoryLeak(sut)
        
        sut.loadViewIfNeeded()
    }
}


