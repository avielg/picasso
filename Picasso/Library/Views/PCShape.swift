//
//  PCShape.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

struct PCShapeView: PCView {
    static let names = ["shape"]

    private let shape: PCShape
    private let fill: ShapePaint?
    private let stroke: ShapePaint?
    private let lineWidth: CGFloat?

    private let modifiers: PCModifiersData?

    var body: some View {
        shape
            .stroke(stroke?.content ?? AnyShapeStyle(Color.clear), lineWidth: lineWidth ?? 1)
            .background(shape.fill(fill?.content ?? AnyShapeStyle(Color.clear)))
            .modifier(Parser.shared.modifiers(from: modifiers))
    }

    init(
        _ shape: PCShape,
        fill: ShapePaint? = nil,
        stroke: ShapePaint? = nil,
        lineWidth: CGFloat? = nil,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.shape = shape
        self.fill = fill
        self.stroke = stroke
        self.lineWidth = lineWidth
        self.modifiers = modifiers().data()
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(shape, fill: fill, stroke: stroke, lineWidth: lineWidth, modifiers: modifiers)
    }
}

enum PCShape: Shape, Codable {
    case rectangle(cornerRadius: CGFloat?)
    case circle
    case capsule(style: RoundedCornerStyle?)

    func path(in rect: CGRect) -> Path {
        switch self {
        case .rectangle(let cornerRadius): RoundedRectangle(cornerRadius: cornerRadius ?? 0).path(in: rect)
        case .circle: Circle().path(in: rect)
        case .capsule(let style): Capsule(style: style ?? .continuous).path(in: rect)
        }
    }
}
