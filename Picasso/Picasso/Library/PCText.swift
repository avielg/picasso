//
//  PiText.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI
import AnyCodable

func textExample() -> some View {
    VStack {
        Text("TEXT")
        Parser.view(from: text_json1)
        Parser.view(from: text_json2)
        Parser.view(from: text_json3)
        Parser.view(from: text_json4)
    }
}

struct PCText: View, Codable {
    enum Keys: CodingKey {
        case text, modifiers
    }

    let text: String
    let modifiers: [PCModifierData]

    var body: some View {
        Text(text)
            .modifier(Parser.modifiers(from: modifiers))
    }

    init(text: String, modifiers: [PCModifierData]) {
        self.text = text
        self.modifiers = modifiers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.modifiers = try container.decodeIfPresent([PCModifierData].self, forKey: .modifiers) ?? []
    }
}

#Preview {
    textExample()
}
