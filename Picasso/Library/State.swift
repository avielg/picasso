//
//  State.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SwiftUI

@MainActor
class PCContext {
    static let shared = PCContext()
    private var flags = [String: Flag]()

    func flag(_ key: String) -> Flag {
        flags[key, default: {
            let newFlag = Flag()
            flags[key] = newFlag
            return newFlag
        }()]
    }
}

class Flag: ObservableObject {
    @Published var value: Bool = false
}
