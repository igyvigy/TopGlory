//
//  EnumExtension.swift
//  TG
//
//  Created by Andrii Narinian on 8/6/17.
//  Copyright © 2017 ROLIQUE. All rights reserved.
//

import Foundation

extension RawRepresentable {
    var r: RawValue {
        return rawValue
    }
}

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
