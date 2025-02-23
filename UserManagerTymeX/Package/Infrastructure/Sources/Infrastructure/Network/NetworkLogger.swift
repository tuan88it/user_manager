//
//  NetworkLogger.swift
//  Infrastructure
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Alamofire
import Foundation

public protocol NetworkLoggerProtocol {
    func log(error: Error, response: HTTPURLResponse?)
}

public final class NetworkLogger: NetworkLoggerProtocol {
    public init() {}
    
    public func log(error: Error, response: HTTPURLResponse?) {
        guard let response = response else {
            debugPrint("🌐 ❌ ERROR: \(error.localizedDescription)")
            return
        }
        
        let statusCode = response.statusCode
        let errorDescription = error.localizedDescription
        
        debugPrint("🌐 ❌ FAILURE [\(statusCode)] - \(response.url?.absoluteString ?? "Unknown URL"): \(errorDescription)")
    }
}
