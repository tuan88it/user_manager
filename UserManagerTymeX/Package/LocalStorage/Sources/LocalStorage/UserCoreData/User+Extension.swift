//
//  User+Extension.swift
//  LocalStorage
//
//  Created by nguyen minh tuan on 2/19/25.
//

import Domain
import Foundation
import CoreData

extension Array where Element == User {
    func toLocal(context: NSManagedObjectContext) -> [CDUser] {
        return map { CDUser(context, user: $0) }
    }
}
extension Array where Element == CDUser {
    func toModels() -> [User] {
        return map { User(from: $0) }
    }
}

// MARK: - Versioning

public extension CoreDataStack.Version {
    static var actual: UInt { 1 }
}

extension CoreDataStack {
    public struct Version {
        private let number: UInt

        init(_ number: UInt) {
            self.number = number
        }

        var modelName: String {
            return "LocalUserData"
        }

        func dbFileURL(_ directory: FileManager.SearchPathDirectory,
            _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            return FileManager.default
                .urls(for: directory, in: domainMask).first?
                .appendingPathComponent(subpathToDB)
        }

        private var subpathToDB: String {
            return "LocalUserData.sql"
        }
    }
}
