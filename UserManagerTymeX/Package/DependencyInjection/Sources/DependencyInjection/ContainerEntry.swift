//
//  ContainerEntry.swift
//  DependencyInjection
//
//  Created by nguyen minh tuan on 2/23/25.
//

public final class ContainerEntry {
    internal let argumentsType: Any.Type
    internal let factory: Any
    
    internal init(argumentsType: Any.Type, factory: Any) {
        self.argumentsType = argumentsType
        self.factory = factory
    }
}
