//
//  PCText+View.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCText: PCView {
    var body: some View {
        Text(text)
            .modifier(Parser.shared.modifiers(from: modifiers))
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(text, modifiers: modifiers)
    }
}
