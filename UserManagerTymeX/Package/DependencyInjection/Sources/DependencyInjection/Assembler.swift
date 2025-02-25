//
//  Assembler.swift
//  DependencyInjection
//
//  Created by nguyen minh tuan on 2/23/25.
//

import Foundation

@MainActor
public protocol Assembly {
    func assemble(container: Container)
}
@MainActor
public final class Assembler {
    private let container: Container
    
    public convenience init(assemblies: [Assembly], container: Container? = Container()) {
        if let container = container {
            self.init(assemblies, container: container)
        } else {
            self.init(assemblies)
        }
    }
    public init(_ assemblies: [Assembly], container: Container = Container()) {
        self.container = container
        run(assemblies: assemblies)
    }
    // MARK: Private
    
    private func run(assemblies: [Assembly]) {
        // build the container from each assembly
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
    }
}
