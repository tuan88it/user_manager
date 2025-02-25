import XCTest
import RxSwift
import RxBlocking
import Infrastructure
import Alamofire
import LocalStorage
import Domain

@testable import Data

class MockNetworkClient<T: URLRequestConvertible>: NetworkClient<T> {
    var mockUsers: [UserDTO] = [
        UserDTO(login: "jvantuyl", id: 101, avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", url: "https://api.github.com/users/jvantuyl", htmlUrl: "https://github.com/jvantuyl"),
        UserDTO(login: "BrianTheCoder", id: 102, avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4", url: "https://api.github.com/users/BrianTheCoder", htmlUrl: "https://github.com/BrianTheCoder")
    ]
    var mockUserDetail: UserDetailDTO = UserDetailDTO(login: "jvantuyl", id: 101, avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", url: "https://api.github.com/users/jvantuyl", htmlUrl: "https://github.com/jvantuyl", name: "Jayson Vantuyl", blog: "http://souja.net", location: "Plumas County, California, USA", followers: 66, following: 15)

    func request<R>(_ target: UserRouter) -> Single<R> where R: Decodable {
        switch target {
        case .users:
            return Single.just(mockUsers as! R)
        case .userDetail:
            return Single.just(mockUserDetail as! R)
        }
    }
    func request(_ request: Infrastructure.UserRouter) -> RxSwift.Single<Void> {
        return Single.create { subcriber in
            return Disposables.create()
        }
    }
}

class MockUserCoreData: UserCoreData {
    var savedUsers: [User] = [
        User(userId: 101, login: "jvantuyl", avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", htmlUrl: "https://github.com/jvantuyl"),
        User(userId: 102, login: "BrianTheCoder", avatarUrl: "https://avatars.githubusercontent.com/u/102?v=4", htmlUrl: "https://github.com/BrianTheCoder")
    ]
    var savedUserDetail: UserDetail = UserDetail(userId: 101, name: "Jayson Vantuyl", login: "jvantuyl", avatarUrl: "https://avatars.githubusercontent.com/u/101?v=4", htmlUrl: "https://github.com/jvantuyl", location: "Plumas County, California, USA", followers: 66, following: 15, blog: "")

    func saves(_ users: [Domain.User]) -> RxSwift.Observable<[Domain.User]> {
        return Observable.just(savedUsers)
    }

    func load() -> RxSwift.Observable<[Domain.User]> {
        return Observable.just(savedUsers)
    }

    func update(_ userDetail: Domain.UserDetail) -> RxSwift.Observable<[Domain.UserDetail]> {
        return Observable.just([savedUserDetail])
    }

    func delete() -> RxSwift.Observable<Void> {
        return Observable.just(())
    }

    func saves(_ users: [User]) -> Observable<Void> {
        self.savedUsers = users
        return .just(())
    }

    func load(perPage: Int) -> Observable<[User]> {
        return .just(savedUsers)
    }

    func loadUserDetail(userName: String) -> Observable<UserDetail> {
        return .just(savedUserDetail)
    }

    func save(_ userDetail: UserDetail) -> Observable<UserDetail> {
        self.savedUserDetail = userDetail
        return .just(userDetail)
    }
}

class MockDataMapper: DataMapper {
    func map(_ dto: UserDTO) -> User {
        return User(userId: dto.id, login: dto.login, avatarUrl: dto.avatarUrl, htmlUrl: dto.htmlUrl)
    }

    func map(_ dto: UserDetailDTO) -> UserDetail {
        return UserDetail(userId: dto.id, name: dto.name, login: dto.login, avatarUrl: dto.avatarUrl, htmlUrl: dto.htmlUrl, location: dto.location, followers: dto.followers ?? 0, following: dto.following ?? 0, blog: "")
    }
}
