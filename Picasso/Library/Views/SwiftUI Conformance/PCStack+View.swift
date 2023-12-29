//
//  PCStack+View.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCStack: PCView {
    private var getSpacing: CGFloat? {
        if let spacing { CGFloat(spacing) }
        else { nil }
    }

    private var layout: any Layout {
        switch axis {
        case .vStack:
            return VStackLayout(alignment: (alignment ?? .center).toAlignment.horizontal, spacing: getSpacing)
        case .hStack:
            return HStackLayout(alignment: (alignment ?? .center).toAlignment.vertical, spacing: getSpacing)
        case .zStack:
            return ZStackLayout(alignment: (alignment ?? .center).toAlignment)
        }
    }

    var body: some View {
        AnyLayout(layout) {
            ForEach(content.indices, id: \.self) {
                content[$0]
            }
            .modifier(Parser.shared.modifiers(from: modifiers))
        }
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(axis, spacing: spacing, alignment: alignment, modifiers: modifiers, content: { content })
    }
}
