//
//  PiText.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import AnyCodable

struct PCText: Codable {
    static var names: [String] { ["text"] }

    let text: String
    let modifiers: PCModifiersData?

    init(text: String, modifiers: PCModifiersData? = nil) {
        self.text = text
        self.modifiers = modifiers
    }
}
