//
//  MockInfrastructure.swift
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

struct MockUserDTO: Decodable {
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

enum MockUserRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        return try URLRequest(url: "", method: .get)
    }
    case users(since: Int, perPage: Int)
    case userDetail(userName: String)
}

final class MockNetworkClient<T: URLRequestConvertible>: NetworkClientProtocol {
    typealias Request = T
    let mockResult: Result<Data, Error>
    
    init(mockResult: Result<Data, Error>) {
        self.mockResult = mockResult
    }
    
    func request<R>(_: T) -> Single<R> where R: Decodable {
        switch mockResult {
            case let .success(data):
                return .just(try! JSONDecoder().decode(R.self, from: data))
            case let .failure(error):
                return .error(error)
        }
    }
    
    func request(_: T) -> Single<Void> {
        switch mockResult {
            case .success:
                return .just(())
            case let .failure(error):
                return .error(error)
        }
    }
}
