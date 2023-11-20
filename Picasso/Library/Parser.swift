//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI

extension [PCModifierData] {
    subscript(_ key: String) -> PCModifierData? {
        first { $0["_type"]!.value as! String == key }
    }
}

enum Parser {
    

    static func view(from json: String) -> some View {
        do {
            let data = json.data(using: .utf8)!
            return try _view(from: data)
        } catch {
            return try! _view(from: error.viewJSONData)
        }
    }

    static func view(from dictionary: [String: AnyCodable]) -> some View {
        do {
            let encoder = JSONEncoder()
            let json = try! encoder.encode(dictionary)
            return try _view(from: json, dictionary: dictionary)
        } catch {
            return try! _view(from: error.viewJSONData)
        }
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
    static func modifiers(from dictionaries: [PCModifierData]) throws -> some PCModifier {
        if let font = dictionaries[FontModifier.name] {
            let data = try JSONEncoder().encode(font)
            try JSONDecoder().decode(FontModifier.self, from: data)
        }
        if let foregroundColor = dictionaries[ForegroundColorModifier.name] {
            let data = try JSONEncoder().encode(foregroundColor)
            try JSONDecoder().decode(ForegroundColorModifier.self, from: data)
        }
        if let lineLimit = dictionaries[LineLimitModifier.name] {
            let data = try JSONEncoder().encode(lineLimit)
            try JSONDecoder().decode(LineLimitModifier.self, from: data)
        }
        if let textAlign = dictionaries[TextAlignModifier.name] {
            let data = try JSONEncoder().encode(textAlign)
            try JSONDecoder().decode(TextAlignModifier.self, from: data)
        }
        if let padding = dictionaries[PaddingModifier.name] {
            let data = try JSONEncoder().encode(padding)
            try JSONDecoder().decode(PaddingModifier.self, from: data)
        }
        if let frameModifier = dictionaries[FrameModifier.name] {
            let data = try JSONEncoder().encode(frameModifier)
            try JSONDecoder().decode(FrameModifier.self, from: data)
        }

        //        switch name {
        //        case "font": try! JSONDecoder().decode(FontModifier.self, from: data)
        //        case "foregroundColor": try! JSONDecoder().decode(ForegroundColorModifier.self, from: data)
        ////        case "concat": try! JSONDecoder().decode(ConcatModifier.self, from: data)
        //        default: EmptyModifier()
        //        }
    }

    @ViewBuilder
    static private func _view(from data: Data, dictionary: [String: AnyCodable]? = nil) throws -> some View {
        switch try _getTypeName(data: data, dictionary: dictionary) {
        case "Text": try JSONDecoder().decode(PCText.self, from: data)
        case "Stack": try JSONDecoder().decode(PCStack.self, from: data)
        case "ScrollView": try JSONDecoder().decode(PCScrollView.self, from: data)
        case "Shape": try JSONDecoder().decode(PCShapeView.self, from: data)
        case "Image": try JSONDecoder().decode(PCAsyncImage.self, from: data)
        default: fatalError()
        }
    }

    static private func _getTypeName(data: Data, dictionary: [String: AnyCodable]?) throws -> String {
        let jsonObj: [String: AnyCodable]
        if let dictionary {
            jsonObj = dictionary
        } else {
            let decoder = JSONDecoder()
            jsonObj = try decoder.decode([String: AnyCodable].self, from: data)
        }

        if let type = jsonObj["_type"]?.value as? String {
            return type
        }
        throw CodableError.decodeError(value: "\(jsonObj)")
    }
}
