//
//  ModifiersSupport.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import AnyCodable
import SwiftUI

typealias PCModifiersData = [String: AnyCodable]

protocol PCModifier: ViewModifier, Codable {
    static var name: String { get }
}

@resultBuilder
struct ModifierBuilder {

//    static func buildBlock() -> some PCModifier {
//        EmptyModifier()
//    }
//
//    static func buildBlock<A: PCModifier>(_ component: A) -> some PCModifier {
//        component
//    }

    static func buildPartialBlock<F: PCModifier>(first: F) -> some PCModifier {
        first
    }

    static func buildPartialBlock<B: PCModifier, C: PCModifier>(accumulated: B, next: C) -> some PCModifier {
        _ConcatModifier(rhs: accumulated, lhs: next)
    }

//    static func buildFinalResult<R: PCModifier>(_ component: R) -> some PCModifier {
//        component
//    }

    static func buildEither<DTrue: PCModifier, EFalse: PCModifier>(first component: DTrue) -> some PCModifier {
        _ConditionalModifier<DTrue, EFalse>(.trueContent(component))
    }

    static func buildEither<DTrue: PCModifier, EFalse: PCModifier>(second component: EFalse) -> some PCModifier {
        _ConditionalModifier<DTrue, EFalse>(.falseContent(component))
    }



//
//    static func buildFinalResult<F: PCModifier>(_ component: F) -> some PCModifier {
//        ConcatModifier(rhs: component, lhs: current)
//    }
//
//    static func buildExpression<H: PCModifier>(_ expression: H) -> some PCModifier {
//        ConcatModifier(rhs: expression, lhs: current)
//    }
//
    static func buildOptional<I: PCModifier>(_ component: I?) -> some PCModifier {
        _OptionalModifier(modifier: component)
    }
}

///
/// These modifiers are only meant for ``ModifierBuilder`` but should never be encoded or decoded.
///

private struct _ConditionalModifier<TrueContent: PCModifier, FalseContent: PCModifier>: PCModifier {
    static var name: String { fatalError() }

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


private struct _ConcatModifier<A: PCModifier, B: PCModifier>: PCModifier {
    static var name: String { fatalError() }

    let rhs: A
    let lhs: B

    func body(content: Content) -> some View {
        content.modifier(rhs).modifier(lhs)
    }
}

private struct _OptionalModifier<A: PCModifier>: PCModifier {
    static var name: String { fatalError() }

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
    static var name: String { fatalError() }
    
    public func encode(to encoder: Encoder) throws {
        try "empty".encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        self = EmptyModifier()
    }
}
