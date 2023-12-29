//
//  Modifiers.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import SwiftUI

struct FontModifier: PCModifier {
    static var name: String { "font" }

    let font: Font

    init(_ font: Font) {
        self.font = font
    }

    func body(content: Content) -> some View {
        let attributes = font.attributes
        
        content.font(attributes.style, weight: attributes.weight, design: attributes.design)
    }
}

struct ForegroundColorModifier: PCModifier {
    static var name: String { "foregroundColor"  }

    let foregroundColor: Color

    init(_ foregroundColor: Color) {
        self.foregroundColor = foregroundColor
    }

    func body(content: Content) -> some View {
        content.foregroundColor(foregroundColor)
    }
}

struct LineLimitModifier: PCModifier {
    static var name: String { "lineLimit" }

    let lineLimit: ClosedRange<Int>

    init(_ lineLimit: ClosedRange<Int>) {
        self.lineLimit = lineLimit
    }

    func body(content: Content) -> some View {
        content.lineLimit(lineLimit)
    }
}

struct TextAlignModifier: PCModifier {
    static var name: String { "alignment" }
    
    let alignment: TextAlignment

    init(_ alignment: TextAlignment) {
        self.alignment = alignment
    }

    func body(content: Content) -> some View {
        content.multilineTextAlignment(alignment)
    }
}

struct PaddingModifier: PCModifier {
    static var name: String { "padding" }

    let padding: EdgeInsets

    init(_ padding: EdgeInsets) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content.padding(
            padding
        )
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

    init(_ frame: Frame) {
        self.frame = frame
    }

    func body(content: Content) -> some View {
        content
            .frame(width: frame.width, height: frame.height, alignment: frame.alignment ?? .center)
            .frame(minWidth: frame.minWidth, idealWidth: frame.idealWidth, maxWidth: frame.maxWidth, minHeight: frame.minHeight, idealHeight: frame.idealHeight, maxHeight: frame.maxHeight, alignment: frame.alignment ?? .center)
    }
}

struct BackgroundModifier: PCModifier {
    static var name: String { "background" }

    struct Background: Codable {
        let content: AnyPCView
        let alignment: Alignment?
    }

    let background: Background

    func body(content: Content) -> some View {
        content.background(
            alignment: background.alignment ?? .center,
            content: { background.content }
        )
    }

    init<V: PCView>(_ content: V, alignment: Alignment? = nil) {
        self.background = .init(content: AnyPCView(content), alignment: alignment)
    }
}

struct OverlayModifier: PCModifier {
    static var name: String { "overlay" }

    struct Overlay: Codable {
        let content: AnyPCView
        let alignment: Alignment?
    }

    let overlay: Overlay

    init<V: PCView>(_ content: V, alignment: Alignment? = nil) {
        self.overlay = .init(content: AnyPCView(content), alignment: alignment)
    }

    func body(content: Content) -> some View {
        content.overlay(
            alignment: overlay.alignment ?? .center,
            content: { overlay.content }
        )
    }
}

struct SheetModifier: PCModifier {
    static var name: String { "sheet" }

    struct Sheet: Codable {
        let content: AnyPCView
        let presentationFlag: String
    }

    private let sheet: Sheet

    @ObservedObject private var flag: Flag

    func body(content: Content) -> some View {
        content.sheet(isPresented: $flag.value) {
            sheet.content
        }
    }

    enum Keys: CodingKey { case sheet }

    init<V: PCView>(presentationFlag: String, content: V) {
        sheet = .init(
            content: AnyPCView(content),
            presentationFlag: presentationFlag
        )
        flag = PCContext.shared.flag(sheet.presentationFlag)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        sheet = try container.decode(Sheet.self, forKey: .sheet)
        flag = PCContext.shared.flag(sheet.presentationFlag)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(sheet, forKey: .sheet)
    }
}
