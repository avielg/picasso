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

    private let text: String
    private let modifiers: [PCModifierData]?

    var body: some View {
        Text(text)
            .modifier(try! Parser.modifiers(from: modifiers ?? []))
    }
}

struct PCText_Previews: PreviewProvider {
    static var previews: some View {
        textExample()
    }
}
