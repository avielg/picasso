//
//  PCViewData.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import AnyCodable

typealias PCViewData = [String: AnyCodable]

extension PCViewData: Identifiable {
    public var id: Int {
        createUniqueID()
    }

    func createUniqueID() -> Int {
        /// Causes collisions...
//        var hasher = Hasher()
//        for (key, value) in self {
//            hasher.combine(key)
//            hasher.combine(value)
//        }
//        return hasher.finalize()

        self
            .map { "\($0.key)-\($0.value)" }
            .joined(separator: ",")
            .hashValue
    }
}
