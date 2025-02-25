//
//  UserRouter.swift
//  Infrastructure
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Foundation
import Alamofire

public enum UserRouter: URLRequestConvertible {
    static let baseUrl = "https://api.github.com"
    case users(offset: Int, perPage: Int)
    case userDetail(userName: String)
    
    var endpoint: String {
        switch self {
            case .users:
                return UserRouter.baseUrl + "/users"
            case .userDetail(let userName):
                return UserRouter.baseUrl + "/users/\(userName)"
        }
    }
    
    func requestHeader() -> [String: String] {
        return ["Content-Type": "application/json;charset=utf-8"]
    }
    
    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let url = try self.path.asURL()
        var urlRequest = URLRequest(url: url)
        //Http method
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = self.requestHeader()
        return try self.encoding.encode(urlRequest, with: parameters)
    }
    private var encoding: ParameterEncoding {
        switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
        }
    }
    
    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
            default:
                return .get
        }
    }
    
    private var path: String {
        return self.endpoint
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
            case .users(let since, let perPage):
                return [
                    "since": since,
                    "per_page": perPage,
                ]
            default:
                return nil
        }
    }
}
