//
//  PiText.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI
import AnyCodable

let text_json1 = """
{
  "_type": "Text",
  "text": "Hello One",
  "modifiers": [
    { "_type": "font", "font": { "weight": "bold", "style": "title" } }
  ]
}
"""

let text_json2 = """
{
  "_type": "Text",
  "text": "The Sony a7C II is the brand's second-generation compact rangefinder-style full-frame camera. Similar in design to Its predecessor, the a7C II uses the same fantastic 33MP BSI sensor from the larger Sony a7 IV and boasts impressive still, video and autofocus capabilities that should appeal to a wide range of users.",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "#A10D3C93" },
    { "_type": "lineLimit", "range": [1,3] },
    { "_type": "alignment", "alignment": "trailing" },
  ]
}
"""

let text_json3 = """
{
  "_type": "Text",
  "text": "Hello three",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "0x50a19a" },
    { "_type": "font", "font": { "style": "title2", "weight": "ultralight" } },
  ]
}
"""

let text_json4 = """
{
  "_type": "Text",
  "text": "Hello four",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "orange" },
    { "_type": "font", "font": { "style": "caption", "weight": "black", "design": "serif" } }
  ]
}
"""



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
