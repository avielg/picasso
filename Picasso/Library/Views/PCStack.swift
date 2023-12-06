//
//  PCHStack.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import AnyCodable

struct PCStack: Codable {
    static var names: [String] { [CodingKeys.hStack, .vStack, .zStack].map(\.rawValue) }

    enum Axis { case hStack, vStack, zStack }
    let axis: Axis

    let spacing: Double?
    let alignment: PCAlignment?
    let content: [PCViewData]
    let modifiers: PCModifiersData?

    init(
        _ axis: Axis,
        spacing: Double? = nil,
        alignment: PCAlignment? = nil,
        content: [PCViewData],
        modifiers: PCModifiersData? = nil
    ) {
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
        self.modifiers = modifiers
    }

    enum CodingKeys: String, CodingKey {
        case hStack = "HStack"
        case vStack = "VStack"
        case zStack = "ZStack"
        case spacing, alignment, modifiers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(spacing, forKey: .spacing)
        try container.encode(alignment, forKey: .alignment)
        try container.encode(modifiers, forKey: .modifiers)

        let layoutKey = switch axis {
        case .hStack: CodingKeys.hStack
        case .vStack: CodingKeys.vStack
        case .zStack: CodingKeys.zStack
        }
        try container.encode(content, forKey: layoutKey)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        spacing = try container.decodeIfPresent(Double.self, forKey: .spacing)
        alignment = try container.decodeIfPresent(PCAlignment.self, forKey: .alignment)
        modifiers = try container.decodeIfPresent(PCModifiersData.self, forKey: .modifiers)

        if let hStack = try container.decodeIfPresent([PCViewData].self, forKey: .hStack) {
            axis = .hStack
            content = hStack
        } else if let vStack = try container.decodeIfPresent([PCViewData].self, forKey: .vStack) {
            axis = .vStack
            content = vStack
        } else if let zStack = try container.decodeIfPresent([PCViewData].self, forKey: .zStack) {
            axis = .zStack
            content = zStack
        } else {
            throw CodableError.decodeError(value: "Unexpected stack type")
        }
    }
}

enum PCAlignment: String, Codable {
    case center, leading, trailing, top, bottom,
    topLeading, topTrailing, bottomLeading, bottomTrailing,
    listRowSeparatorLeading, listRowSeparatorTrailing,
    firstTextBaseline, lastTextBaseline
}
