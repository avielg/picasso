//
//  PCHStack.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI
import AnyCodable

func stackExample() -> some View {
    VStack {
        Text("STACK")
        Parser.view(from: stack_json1)
        Parser.view(from: stack_json2)
    }
}

typealias PCViewData = [String: AnyCodable]

extension PCViewData: Identifiable {
    public var id: Int {
        createUniqueID()
    }

    func createUniqueID() -> Int {
        /// Causes collisions...
//        var hasher = Hasher()
//        for (key, value) in self {
//            hasher.combine(key)
//            hasher.combine(value)
//        }
//        return hasher.finalize()

        self
            .map { "\($0.key)-\($0.value)" }
            .joined(separator: ",")
            .hashValue
    }
}

struct PCStack: PCView {
    static var name: String { Keys.stack.stringValue }

    private let layout: any Layout
    private let stack: [PCViewData]
    private let modifiers: PCModifiersData?

    enum Keys: CodingKey { case layout, stack, modifiers }

    var body: some View {
        AnyLayout(layout) {
            ForEach(stack) {
                Parser.view(from: $0)
            }
            .modifier(try! Parser.modifiers(from: modifiers))
        }
    }

    init(layout: any Layout, stack: [PCViewData], modifiers: PCModifiersData? = nil) {
        self.layout = layout
        self.stack = stack
        self.modifiers = modifiers
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(stack, forKey: .stack)
        try container.encode(PCLayoutData.create(from: layout), forKey: .layout)
        try container.encode(modifiers, forKey: .modifiers)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        stack = try container.decode([PCViewData].self, forKey: .stack)
        modifiers = try container.decodeIfPresent(PCModifiersData.self, forKey: .modifiers)

        let layoutData = try container.decode(PCLayoutData.self, forKey: .layout)
        let alignment = layoutData.alignment ?? .center
        switch layoutData.axis {
        case "VStack":
            layout = VStackLayout(alignment: alignment.horizontal, spacing: layoutData.spacing)
        case "HStack": 
            layout = HStackLayout(alignment: alignment.vertical, spacing: layoutData.spacing)
        case "ZStack": 
            layout = ZStackLayout(alignment: alignment)
        default: throw CodableError.decodeError(value: "\(layoutData)")
        }
    }
}

struct PCLayoutData: Codable {
    let axis: String
    let alignment: Alignment?
    let spacing: CGFloat?

    static func create(from layout: any Layout) throws -> Self {
        if let vLayout = layout as? VStackLayout {
            return PCLayoutData(
                axis: "VStack",
                alignment: Alignment(horizontal: vLayout.alignment, vertical: .center),
                spacing: vLayout.spacing
            )
        } else if let hLayout = layout as? HStackLayout {
            return PCLayoutData(
                axis: "HStack",
                alignment: Alignment(horizontal: .center, vertical: hLayout.alignment),
                spacing: hLayout.spacing
            )
        } else if let zLayout = layout as? ZStackLayout {
            return PCLayoutData(
                axis: "ZStack",
                alignment: zLayout.alignment,
                spacing: 0
            )
        }
        throw CodableError.encodeError(value: layout)
    }
}

extension Alignment: Codable {
    public func encode(to encoder: Encoder) throws {
        let rawValue = switch self {
        case .center: "center"
        case .leading: "leading"
        case .trailing: "trailing"
        case .top: "top"
        case .bottom: "bottom"
        case .topLeading: "topLeading"
        case .topTrailing: "topTrailing"
        case .bottomLeading: "bottomLeading"
        case .bottomTrailing: "bottomTrailing"
        case self where horizontal == .listRowSeparatorLeading: "listRowSeparatorLeading"
        case self where horizontal == .listRowSeparatorTrailing: "listRowSeparatorTrailing"
        case self where vertical == .firstTextBaseline: "firstTextBaseline"
        case self where vertical == .lastTextBaseline: "lastTextBaseline"
        default: throw CodableError.decodeError(value: "\(self)")
        }
        try rawValue.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)

        switch rawValue {
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        case "listRowSeparatorLeading": self = .init(horizontal: .listRowSeparatorLeading, vertical: .center)
        case "listRowSeparatorTrailing": self = .init(horizontal: .listRowSeparatorTrailing, vertical: .center)
        case "firstTextBaseline": self = .init(horizontal: .center, vertical: .firstTextBaseline)
        case "lastTextBaseline": self = .init(horizontal: .center, vertical: .lastTextBaseline)
        default: throw CodableError.decodeError(value: rawValue)
        }
    }
}

struct PCStack_Previews: PreviewProvider {
    static var previews: some View {
        stackExample()
    }
}
