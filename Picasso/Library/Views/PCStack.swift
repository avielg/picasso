//
//  PCHStack.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import AnyCodable

struct PCStack: Codable {
    static var name: String { Keys.stack.stringValue }

    let layout: PCLayoutData
    let stack: [PCViewData]
    let modifiers: PCModifiersData?

    enum Keys: CodingKey { case layout, stack, modifiers }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(stack, forKey: .stack)
        try container.encode(layout, forKey: .layout)
        try container.encode(modifiers, forKey: .modifiers)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        stack = try container.decode([PCViewData].self, forKey: .stack)
        modifiers = try container.decodeIfPresent(PCModifiersData.self, forKey: .modifiers)
        layout = try container.decode(PCLayoutData.self, forKey: .layout)
    }
}

struct PCLayoutData: Codable {
    enum Axis: String, Codable {
        case hStack = "HStack"
        case vStack = "VStack"
        case zStack = "ZStack"
    }
    let axis: Axis
    let alignment: PCAlignment?
    let spacing: Double?

    init(axis: Axis, alignment: PCAlignment? = nil, spacing: Double? = nil) {
        self.axis = axis
        self.alignment = alignment
        self.spacing = spacing
    }
}

enum PCAlignment: String, Codable {
    case center, leading, trailing, top, bottom,
    topLeading, topTrailing, bottomLeading, bottomTrailing,
    listRowSeparatorLeading, listRowSeparatorTrailing,
    firstTextBaseline, lastTextBaseline
}
