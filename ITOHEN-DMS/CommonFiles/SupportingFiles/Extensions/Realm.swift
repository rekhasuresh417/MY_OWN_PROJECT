//
//  Realm.swift
//  IDAS iOS
//
//  Created by Dharma sheelan on 12/10/21.
//
import RealmSwift

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
