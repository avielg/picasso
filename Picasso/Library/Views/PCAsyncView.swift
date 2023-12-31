//
//  PCAsyncView.swift
//  Picasso
//
//  Created by Aviel Gross on 28.11.2023.
//

import SwiftUI

struct PCAsyncView: PCView {
    static let names = ["url"]

    private let url: URL

    private let modifiers: PCModifiersData?

    @Environment(\.requestConfig) private var requestConfig

    var body: some View {
        PicassoView(
            URLRequest(url: url).with(requestConfig),
            placeholder: Color.clear
        )
        .modifier(Parser.shared.modifiers(from: modifiers))
    }

    enum Keys: CodingKey { case url, modifiers }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        url = try container.decode(URL.self, forKey: .url)
        modifiers = try container.decode(PCModifiersData.self, forKey: .modifiers)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(url, forKey: .url)
        if let modifiers {
            try container.encode(modifiers, forKey: .modifiers)
        }
    }

    init(
        _ url: URL,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.url = url
        self.modifiers = modifiers().data()
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(url, modifiers: modifiers)
    }
}
