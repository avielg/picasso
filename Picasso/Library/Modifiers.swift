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

    let lineLimit: ClosedRange<Int>

    func body(content: Content) -> some View {
        content.lineLimit(lineLimit)
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

    let padding: EdgeInsets

    func body(content: Content) -> some View {
        content.padding(
            padding
        )
    }
}

extension EdgeInsets: Codable {
    enum Keys: CodingKey {
        case top, leading, trailing, bottom
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self = .init(
            top: try container.decodeIfPresent(CGFloat.self, forKey: .top) ?? 0,
            leading: try container.decodeIfPresent(CGFloat.self, forKey: .leading) ?? 0,
            bottom: try container.decodeIfPresent(CGFloat.self, forKey: .bottom) ?? 0,
            trailing: try container.decodeIfPresent(CGFloat.self, forKey: .trailing) ?? 0
        )
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.top, forKey: .top)
        try container.encode(self.leading, forKey: .leading)
        try container.encode(self.bottom, forKey: .bottom)
        try container.encode(self.trailing, forKey: .trailing)
    }
}

struct FrameModifier: PCModifier {
    static var name: String { "frame" }

    struct Frame: Codable {
        let width: CGFloat?
        let height: CGFloat?
        let minWidth: CGFloat?
        let idealWidth: CGFloat?
        let maxWidth: CGFloat?
        let minHeight: CGFloat?
        let idealHeight: CGFloat?
        let maxHeight: CGFloat?
        let alignment: Alignment?
    }

    let frame: Frame

    func body(content: Content) -> some View {
        content
            .frame(width: frame.width, height: frame.height, alignment: frame.alignment ?? .center)
            .frame(minWidth: frame.minWidth, idealWidth: frame.idealWidth, maxWidth: frame.maxWidth, minHeight: frame.minHeight, idealHeight: frame.idealHeight, maxHeight: frame.maxHeight, alignment: frame.alignment ?? .center)
    }
}

struct BackgroundModifier: PCModifier {
    static var name: String { "background" }

    struct Background: Codable {
        let content: PCViewData
        let alignment: Alignment?
    }

    let background: Background

    func body(content: Content) -> some View {
        content.background(
            Parser.view(from: background.content), alignment: background.alignment ?? .center
        )
    }
}
