//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI

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
        ConcatModifier(rhs: accumulated, lhs: next)
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
        OptionalModifier(modifier: component)
    }
}

extension [PCModifierData] {
    subscript(_ key: String) -> PCModifierData? {
        first { $0["_type"]!.value as! String == key }
    }
}

enum Parser {
    static func view(from json: String) -> some View {
        let data = json.data(using: .utf8)!
        return _view(from: data)
    }

    static func view(from dictionary: [String: AnyCodable]) -> some View {
        let encoder = JSONEncoder()
        let json = try! encoder.encode(dictionary)
        return _view(from: json, dictionary: dictionary)
    }

//    @ModifierBuilder
//    static func check() -> some PCModifier {
//        if true {
//            FontModifier(font: .body)
//        } else {
//            EmptyModifier()
//        }
//    }

    @ModifierBuilder
    static func modifiers(from dictionaries: [PCModifierData]) -> some PCModifier {
        if let font = dictionaries[FontModifier.name] {
            let data = try! JSONEncoder().encode(font)
            try! JSONDecoder().decode(FontModifier.self, from: data)
        }
        if let foregroundColor = dictionaries[ForegroundColorModifier.name] {
            let data = try! JSONEncoder().encode(foregroundColor)
            try! JSONDecoder().decode(ForegroundColorModifier.self, from: data)
        }
        if let lineLimit = dictionaries[LineLimitModifier.name] {
            let data = try! JSONEncoder().encode(lineLimit)
            try! JSONDecoder().decode(LineLimitModifier.self, from: data)
        }
        if let lineLimit = dictionaries[TextAlignModifier.name] {
            let data = try! JSONEncoder().encode(lineLimit)
            try! JSONDecoder().decode(TextAlignModifier.self, from: data)
        }


        //        switch name {
        //        case "font": try! JSONDecoder().decode(FontModifier.self, from: data)
        //        case "foregroundColor": try! JSONDecoder().decode(ForegroundColorModifier.self, from: data)
        ////        case "concat": try! JSONDecoder().decode(ConcatModifier.self, from: data)
        //        default: EmptyModifier()
        //        }
    }

    @ViewBuilder
    static func _view(from data: Data, dictionary: [String: AnyCodable]? = nil) -> some View {
        switch _getTypeName(data: data, dictionary: dictionary) {
        case "Text": try! JSONDecoder().decode(PCText.self, from: data)
        case "Stack": try! JSONDecoder().decode(PCStack.self, from: data)
        default: fatalError()
        }
    }

    static private func _getTypeName(data: Data, dictionary: [String: AnyCodable]?) -> String {
        let jsonObj: [String: AnyCodable]
        if let dictionary {
            jsonObj = dictionary
        } else {
            let decoder = JSONDecoder()
            jsonObj = try! decoder.decode([String: AnyCodable].self, from: data)
        }

        return jsonObj["_type"]!.value as! String
    }
}
