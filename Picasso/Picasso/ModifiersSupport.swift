//
//  ModifiersSupport.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import AnyCodable
import SwiftUI

///
/// These modifiers are only meant for ``ModifierBuilder`` but should never be encoded or decoded.
///

typealias PCModifierData = [String: AnyCodable]

struct _ConditionalModifier<TrueContent: PCModifier, FalseContent: PCModifier>: PCModifier {
    internal enum Storage {
        case trueContent(TrueContent)
        case falseContent(FalseContent)
    }

    enum Keys: CodingKey { case type, storage }

    internal let storage: _ConditionalModifier<TrueContent, FalseContent>.Storage

    init(_ storage: Storage) {
        self.storage = storage
    }

    func body(content: Content) -> some View {
        switch storage {
        case .trueContent(let trueContent):
            content.modifier(trueContent)
        case .falseContent(let falseContent):
            content.modifier(falseContent)
        }
    }

    init(from decoder: Decoder) throws {
        fatalError()
//
//        let container = try decoder.container(keyedBy: Keys.self)
//
//        let type = try container.decode(String.self, forKey: .type)
//        let storage = try container.decode(PCModifier.self, forKey: .storage)
//        switch type {
//        case "TrueContent": self.storage = .trueContent(storage)
//        case "FalseContent": self.storage = .falseContent(storage)
//        default: throw CodableError.decodeError(value: type)
//        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch storage {
        case .trueContent(let trueContent):
            try container.encode("TrueContent", forKey: .type)
            try container.encode(trueContent, forKey: .storage)
        case .falseContent(let falseContent):
            try container.encode("FalseContent", forKey: .type)
            try container.encode(falseContent, forKey: .storage)
        }
    }
}


struct ConcatModifier<A: PCModifier, B: PCModifier>: PCModifier {
    let rhs: A
    let lhs: B

    func body(content: Content) -> some View {
        content.modifier(rhs).modifier(lhs)
    }
}

struct OptionalModifier<A: PCModifier>: PCModifier {
    let modifier: A?

    func body(content: Content) -> some View {
        if let modifier {
            content.modifier(modifier)
        } else {
            content
        }
    }
}

extension EmptyModifier: PCModifier {
    public func encode(to encoder: Encoder) throws {
        try "empty".encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        self = EmptyModifier()
    }
}
