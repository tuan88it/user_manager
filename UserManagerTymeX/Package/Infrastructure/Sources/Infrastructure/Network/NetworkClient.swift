//
//  NetworkClient.swift
//  Infrastructure
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

public protocol NetworkClientProtocol {
    associatedtype Request: URLRequestConvertible
    func request<R: Codable>(_ request: Request) -> Single<R>
    func request(_ request: Request) -> Single<Void>
}

open class NetworkClient<T: URLRequestConvertible>: NetworkClientProtocol {
    public typealias Request = T
    private let provider: NetworkConfiguration
    private let logger: NetworkLogger
    public init (
        provider: NetworkConfiguration = .default,
        logger: NetworkLogger = NetworkLogger()
    ) {
        self.provider = provider
        self.logger = logger
    }
    public func request<R: Codable>(_ request: Request) -> Single<R> {
        return Single.create { [weak self] observer in
            let dataRequest = self?.provider.session.request(request)
                .validate()
                .responseData { [weak self] response in
                switch response.result {
                case .success(let data):
                    do {
                        let decodedObject = try JSONDecoder().decode(R.self, from: data)
                        observer(.success(decodedObject))
                    } catch {
                        self?.logger.log(error: error, response: response.response)
                        observer(.failure(error))
                    }

                case .failure(let error):
                    self?.logger.log(error: error, response: response.response)
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                dataRequest?.cancel()
            }
        }
    }

    public func request(_ request: Request) -> Single<Void> {
        return Single.create { [weak self] observer in
            let dataRequest = self?.provider.session.request(request)
                .validate()
                .response { [weak self] response in
                switch response.result {
                case .success:
                    observer(.success(()))
                case .failure(let error):
                    self?.logger.log(error: error, response: response.response)
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                dataRequest?.cancel()
            }
        }
    }
}
