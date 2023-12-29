//
//  PCColor.swift
//  Picasso
//
//  Created by Aviel Gross on 13.12.2023.
//

import SwiftUI

struct PCColor: PCView {
    static let names = ["color"]

    private let color: Color
    private let modifiers: PCModifiersData?

    var body: some View { color }

    init(
        color: Color,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.color = color
        self.modifiers = modifiers().data()
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(color: color, modifiers: modifiers)
    }
}
