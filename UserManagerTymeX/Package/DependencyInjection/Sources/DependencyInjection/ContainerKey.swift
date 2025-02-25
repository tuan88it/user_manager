//
//  ContainerKey.swift
//  DependencyInjection
//
//  Created by nguyen minh tuan on 2/23/25.
//


import Foundation

// MARK: - ServiceKey
struct ContainerKey {
    internal let serviceType: Any.Type
    internal let argumentsType: Any.Type
    internal let name: String?
    
    init(
        serviceType: Any.Type,
        argumentsType: Any.Type,
        name: String? = nil
    ) {
        self.serviceType = serviceType
        self.argumentsType = argumentsType
        self.name = name
    }
}

// MARK: Hashable
extension ContainerKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(serviceType).hash(into: &hasher)
        ObjectIdentifier(argumentsType).hash(into: &hasher)
        name?.hash(into: &hasher)
    }
}

// MARK: Equatable
extension ContainerKey: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.serviceType == rhs.serviceType
        && lhs.argumentsType == rhs.argumentsType
        && lhs.name == rhs.name
    }
}
