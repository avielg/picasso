//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI
import ZippyJSON

enum Parser {
    static let encoder = JSONEncoder()
    static let decoder = ZippyJSONDecoder()

    static func view(from json: String) -> some View {
        if let data = json.data(using: .utf8) {
            do {
                return try _view(from: data)
            } catch {
                return try! _view(from: error.viewJSONData)
            }
        } else {
            return try! _view(from: CodableError.decodeError(value: json).viewJSONData)
        }
    }

    static func view(from dictionary: [String: AnyCodable]) -> some View {
        do {
            let json = try! encoder.encode(dictionary)
            return try _view(from: json, dictionary: dictionary)
        } catch {
            return try! _view(from: error.viewJSONData)
        }
    }

    static func view(from data: Data) -> some View {
        do {
            return try _view(from: data)
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
    static func modifiers(from dictionary: PCModifiersData?) throws -> some PCModifier {
        if let dictionary, !dictionary.isEmpty {
            let data = try encoder.encode(dictionary)
            if dictionary[FontModifier.name] != nil {
                try decoder.decode(FontModifier.self, from: data)
            }
            if dictionary[ForegroundColorModifier.name] != nil {
                try decoder.decode(ForegroundColorModifier.self, from: data)
            }
            if dictionary[LineLimitModifier.name] != nil {
                try decoder.decode(LineLimitModifier.self, from: data)
            }
            if dictionary[TextAlignModifier.name] != nil {
                try decoder.decode(TextAlignModifier.self, from: data)
            }
            if dictionary[PaddingModifier.name] != nil {
                try decoder.decode(PaddingModifier.self, from: data)
            }
            if dictionary[FrameModifier.name] != nil {
                try decoder.decode(FrameModifier.self, from: data)
            }
            if dictionary[BackgroundModifier.name] != nil {
                try decoder.decode(BackgroundModifier.self, from: data)
            }
        }
        //        switch name {
        //        case "font": try! decoder.decode(FontModifier.self, from: data)
        //        case "foregroundColor": try! decoder.decode(ForegroundColorModifier.self, from: data)
        ////        case "concat": try! decoder.decode(ConcatModifier.self, from: data)
        //        default: EmptyModifier()
        //        }
    }

    @ViewBuilder
    static private func _view(from data: Data, dictionary: [String: AnyCodable]? = nil) throws -> some View {
        switch try _getTypeName(data: data, dictionary: dictionary) {
        case "Text": try decoder.decode(PCText.self, from: data)
        case "Stack": try decoder.decode(PCStack.self, from: data)
        case "ScrollView": try decoder.decode(PCScrollView.self, from: data)
        case "Shape": try decoder.decode(PCShapeView.self, from: data)
        case "Image": try decoder.decode(PCAsyncImage.self, from: data)
        default: fatalError()
        }
    }

    static private func _getTypeName(data: Data, dictionary: [String: AnyCodable]?) throws -> String {
        let jsonObj: [String: AnyCodable]
        if let dictionary {
            jsonObj = dictionary
        } else {
            jsonObj = try decoder.decode([String: AnyCodable].self, from: data)
        }

        if let type = jsonObj["_type"]?.value as? String {
            return type
        }
        throw CodableError.decodeError(value: "\(jsonObj)")
    }
}
