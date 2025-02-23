// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class Container: ContainerProtocol {
    private var dependencies: [ContainerKey: ContainerEntry] = [:]

    public init() {

    }

    /// Removes all registrations in the container.
    public func removeAll() {
        dependencies.removeAll()
    }

    func _register<Service, Arguments>(
        _ serviceType: Service.Type,
        factory: @escaping (Arguments) -> Any,
        name: String? = nil
    ) {
        let key = ContainerKey(serviceType: Service.self, argumentsType: Arguments.self, name: name)
        let entry = ContainerEntry(
            argumentsType: Arguments.self,
            factory: factory
        )
        dependencies[key] = entry
    }
}
extension Container {

    public func register<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
    ) {
        _register(serviceType, factory: factory, name: name)
    }

    public func register<Service, Arg1>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver, Arg1) -> Service
    ) {
        return _register(serviceType, factory: factory, name: name)
    }

    public func register<Service, Arg1, Arg2>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver, Arg1, Arg2) -> Service
    ) {
        return _register(serviceType, factory: factory, name: name)
    }
}
extension Container: Resolver {

    // MARK: - Resolver

    fileprivate func getEntry(for key: ContainerKey) -> ContainerEntry? {
        return dependencies[key]
    }

    fileprivate func resolve<Service, Factory>(
        entry: ContainerEntry,
        invoker: (Factory) -> Any
    ) -> Service? {
        let resolvedInstance = invoker(entry.factory as! Factory)
        return resolvedInstance as? Service
    }

    public func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        return resolve(serviceType, name: nil)
    }

    public func resolve<Service>(_: Service.Type, name: String?) -> Service? {
        return _resolve(name: name) { (factory: (Resolver) -> Any) in factory(self) }
    }

    public func resolve<Service, Arg1>(_ serviceType: Service.Type, argument: Arg1) -> Service? {
        return resolve(serviceType, name: nil, argument: argument)
    }

    public func resolve<Service, Arg1>(_ serviceType: Service.Type, name: String?, argument: Arg1) -> Service? {
        typealias FactoryType = ((Resolver, Arg1)) -> Any
        return _resolve(name: name) { (factory: FactoryType) in factory((self, argument)) }
    }

    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        return resolve(serviceType, name: nil, arguments: arg1, arg2)
    }

    public func resolve<Service, Arg1, Arg2>(_ serviceType: Service.Type, name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> Service? {
        typealias FactoryType = ((Resolver, Arg1, Arg2)) -> Any
        return _resolve(name: name) { (factory: FactoryType) in factory((self, arg1, arg2)) }
    }

    public func _resolve<Service, Arguments>(
        name: String?,
        invoker: @escaping ((Arguments) -> Any) -> Any
    ) -> Service? {
        var resolvedInstance: Service?
        let key = ContainerKey(serviceType: Service.self, argumentsType: Arguments.self, name: name)

        if let entry = getEntry(for: key) {
            resolvedInstance = resolve(entry: entry, invoker: invoker)
        }
        return resolvedInstance
    }



}
