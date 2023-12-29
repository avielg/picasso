//
//  PCPageView.swift
//  Picasso
//
//  Created by Aviel Gross on 26.12.2023.
//

import SwiftUI

struct PCPageView: PCView {
    static var names = ["pages"]

    enum IndexDisplay: Codable { case automatic, never, always }

    private let pages: [AnyPCView]
    private let indexDisplay: IndexDisplay?
    private let modifiers: PCModifiersData?

    var body: some View {
        TabView {
            ForEach(pages.indices, id: \.self) {
                pages[$0]
            }
        }
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: (indexDisplay ?? .automatic).converted)
        )
        .modifier(Parser.shared.modifiers(from: modifiers))
    }

    init(
        indexDisplay: IndexDisplay? = nil,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() },
        @PCViewBuilder pages: () -> [AnyPCView]
    ) {
        self.pages = pages()
        self.indexDisplay = indexDisplay
        self.modifiers = modifiers().data()
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(indexDisplay: indexDisplay, modifiers: modifiers, pages: { pages })
    }
}

extension PCPageView.IndexDisplay {
    var converted: PageTabViewStyle.IndexDisplayMode {
        switch self {
        case .automatic: .automatic
        case .never: .never
        case .always: .always
        }
    }
}
