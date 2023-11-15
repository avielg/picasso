//
//  Modifiers.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import AnyCodable
import SwiftUI

struct FontModifier: PCModifier {
    let font: Font

    func body(content: Content) -> some View {
        content.font(font)
    }
}

struct ForegroundColorModifier: PCModifier {
    let foregroundColor: Color

    func body(content: Content) -> some View {
        content.foregroundColor(foregroundColor)
    }
}

struct LineLimitModifier: PCModifier {
    let range: ClosedRange<Int>

    func body(content: Content) -> some View {
        content.lineLimit(range)
    }
}

struct TextAlignModifier: PCModifier {
    let alignment: TextAlignment

    func body(content: Content) -> some View {
        content.multilineTextAlignment(alignment)
    }
}
