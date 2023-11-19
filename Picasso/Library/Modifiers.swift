//
//  Modifiers.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import AnyCodable
import SwiftUI

struct FontModifier: PCModifier {
    static var name: String { "font" }

    let font: Font

    func body(content: Content) -> some View {
        content.font(font)
    }
}

struct ForegroundColorModifier: PCModifier {
    static var name: String { "foregroundColor"  }

    let foregroundColor: Color

    func body(content: Content) -> some View {
        content.foregroundColor(foregroundColor)
    }
}

struct LineLimitModifier: PCModifier {
    static var name: String { "lineLimit" }

    let range: ClosedRange<Int>

    func body(content: Content) -> some View {
        content.lineLimit(range)
    }
}

struct TextAlignModifier: PCModifier {
    static var name: String { "alignment" }
    
    let alignment: TextAlignment

    func body(content: Content) -> some View {
        content.multilineTextAlignment(alignment)
    }
}

struct PaddingModifier: PCModifier {
    static var name: String { "padding" }

    let top: CGFloat?
    let bottom: CGFloat?
    let leading: CGFloat?
    let trailing: CGFloat?

    func body(content: Content) -> some View {
        content.padding(
            EdgeInsets(
                top: top ?? 0,
                leading: leading ?? 0,
                bottom: bottom ?? 0,
                trailing: trailing ?? 0
            )
        )
    }
}
