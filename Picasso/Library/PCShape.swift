//
//  PCShape.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

struct PCShapeView: View, Codable {
    private let shape: PCShape
    private let fill: ShapePaint?
    private let stroke: ShapePaint?
    private let lineWidth: CGFloat?

    private let modifiers: [PCModifierData]?

    var body: some View {
        shape
            .stroke(stroke?.content ?? AnyShapeStyle(Color.clear), lineWidth: lineWidth ?? 0)
            .background(shape.fill(fill?.content ?? AnyShapeStyle(Color.clear)))
            .modifier(try! Parser.modifiers(from: modifiers ?? []))
    }
}

struct PCShape: Shape, Codable {
    
    enum ShapeType: Codable {
        case rectangle(cornerRadius: CGFloat)
        case circle
        case capsule(style: RoundedCornerStyle?)
    }

    private let type: ShapeType

    func path(in rect: CGRect) -> Path {
        switch type {
        case .rectangle(let cornerRadius): RoundedRectangle(cornerRadius: cornerRadius).path(in: rect)
        case .circle: Circle().path(in: rect)
        case .capsule(let style): Capsule(style: style ?? .continuous).path(in: rect)
        }
    }
}

func shapesExample() -> some View {
    VStack {
        Parser.view(from: shape_json1)
    }
}

#Preview {
    shapesExample()
}
