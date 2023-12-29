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

internal extension PCModifier {
    func data() -> PCModifiersData {
        try! jsonData().dictionary()
    }
}

internal extension Encodable {
    func jsonData() throws -> Data {
        try Parser.shared.encoder.encode(self)
    }
}

internal extension Data {
    func dictionary() throws -> [String: AnyCodable] {
        try Parser.shared.decoder.decode([String: AnyCodable].self, from: self)
    }
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

    static func buildIf<M: PCModifier>(_ component: M?) -> M? {
        component
    }
}

///
/// These modifiers are only containers for ``ModifierBuilder`` but should never be decoded.
/// When encoded they are flattened and encoded to the actual type of the modifier they contain.
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

    init(from decoder: Decoder) throws { fatalError() }

    func encode(to encoder: Encoder) throws {
        switch storage {
        case .trueContent(let trueContent):
            try trueContent.encode(to: encoder)
        case .falseContent(let falseContent):
            try falseContent.encode(to: encoder)
        }
    }
}

//enum PCModifiersTypes {
//    enum Kind: String, CodingKey {
//        case font, foregroundColor, lineLimit, alignment, padding, frame, background, overlay, sheet
//    }
//
//    static let types: [(Kind, any PCModifier.Type)] = [
//        (.font, FontModifier.self),
//        (.foregroundColor, ForegroundColorModifier.self),
//        (.lineLimit, LineLimitModifier.self),
//        (.alignment, TextAlignModifier.self),
//        (.padding, PaddingModifier.self),
//        (.frame, FrameModifier.self),
//        (.background, BackgroundModifier.self),
//        (.overlay, OverlayModifier.self),
//        (.sheet, SheetModifier.self)
//    ]
//}
//
//extension PCModifier {
//    func encode(into container: inout KeyedEncodingContainer<PCModifiersTypes.Kind>) throws {
//        for (kind, modifierType) in PCModifiersTypes.types {
//            if type(of: self) == modifierType {
//                try container.encode(self, forKey: kind)
//            }
//        }
//    }
//}

private struct _ConcatModifier<A: PCModifier, B: PCModifier>: PCModifier {
    static var name: String { fatalError() }

    let rhs: A
    let lhs: B

    func body(content: Content) -> some View {
        content.modifier(rhs).modifier(lhs)
    }

    func encode(to encoder: Encoder) throws {
        try [rhs.data(), lhs.data()].merged.encode(to: encoder)

        // need to find a way to encode `rhs` and `lhs` directly to the same dictionary
        // and not as the value of a key since they contain the right key in their value.
//        var container = encoder.container(keyedBy: PCModifiersTypes.Kind.self)
//        try rhs.encode(into: &container)
//        try lhs.encode(into: &container)
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

    func encode(to encoder: Encoder) throws {
        if let modifier {
            try modifier.encode(to: encoder)
        }
    }
}

struct PCEmptyModifier: PCModifier {
    static var name: String { fatalError() }

    func body(content: Content) -> some View {
        content
    }
}
