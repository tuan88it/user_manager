//
//  NetworkConfiguration.swift
//  Infrastructure
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Alamofire
import Foundation

public struct NetworkConfiguration : Sendable{
    public let timeout: TimeInterval
    let session: Session
    
    public init(timeout: TimeInterval) {
        self.timeout = timeout
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = timeout
        sessionConfig.timeoutIntervalForResource = timeout
        
        self.session = Session(configuration: sessionConfig)
    }
    public static let `default` = NetworkConfiguration(timeout: 60)
}
