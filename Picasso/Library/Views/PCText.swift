//
//  PiText.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

struct PCText: Codable {
    static var names: [String] { ["text"] }

    let text: String
    let modifiers: PCModifiersData?

    init(
        text: String,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.text = text
        self.modifiers = modifiers().data()
    }
}
