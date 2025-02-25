//
//  UserDetailViewModelTests.swift
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

final class UserDetailViewModelTests: XCTestCase {

    private var viewModel: UserDetailViewModel!
    private var useCase: MockFetchUserDetailUseCase!
    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        useCase = MockFetchUserDetailUseCase()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        useCase = nil
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_viewDidLoad_fetchesUserDetailSuccessfully() {
        let userDetail = UserDetail(
            userId: 101,
            name: "Jayson Vantuyl",
            login: "jvantuyl",
            avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4",
            htmlUrl: "https://github.com/jvantuyl",
            location: "Plumas County, California, USA",
            followers: 66,
            following: 15,
            blog: ""
        )
        useCase.mockResult = .just(userDetail)

        viewModel = UserDetailViewModel(useCase: useCase, login: "testUser")

        let observer = scheduler.createObserver([BaseCellViewModel].self)
        viewModel.cellModels
            .subscribe(observer)
            .disposed(by: disposeBag)

        // Act
        viewModel.viewDidLoad()
        scheduler.start()

        // Assert
        let expectedCells: [Recorded<Event<[BaseCellViewModel]>>] = [
                .next(0, [
                UserCellViewModel(user: nil, userDetail: userDetail),
                UserFollowCellViewModel(userDetail: userDetail),
                UserBlogCellViewModel(userDetail: userDetail)
                ])
        ]
        let data = observer.events.filter { it in
            it.value.element?.count ?? 0 > 0
        }
        data.forEach {
            print($0)
        }
        XCTAssertEqual(data.count, expectedCells.count)
    }
    
    @MainActor
    func test_detailViewModel_doesNotCreateMemoryLeak() {
        let sut = UserDetailViewModel(useCase: useCase, login: "test")
        checkForMemoryLeak(sut)
    }
    @MainActor
    func test_detailViewController_doesNotCreateMemoryLeak() {
        let viewModel = UserDetailViewModel(useCase: useCase, login: "test")
        let sut = UserDetailViewController(viewModel: viewModel, output: UserDetailViewControllerParams(login: "test"))
        checkForMemoryLeak(sut)
        
        sut.loadViewIfNeeded()
    }
    
}


