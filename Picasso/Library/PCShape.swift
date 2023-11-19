//
//  PCShape.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

struct PCShapeView: View, Codable {
    let shape: PCShape
    let fill: ShapePaint?
    let stroke: ShapePaint?
    let lineWidth: CGFloat?

    var body: some View {
        shape
            .stroke(stroke?.content ?? AnyShapeStyle(Color.clear), lineWidth: lineWidth ?? 0)
            .background(shape.fill(fill?.content ?? AnyShapeStyle(Color.clear)))
    }
}

struct PCShape: Shape, Codable {
    
    enum ShapeType: Codable {
        case rectangle(cornerRadius: CGFloat)
        case circle
        case capsule(style: RoundedCornerStyle?)
    }

    let type: ShapeType

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
