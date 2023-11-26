//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI
import ZippyJSON

protocol PCView: View, Codable {
    static var name: String { get }
}

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
            if dictionary[SheetModifier.name] != nil {
                try decoder.decode(SheetModifier.self, from: data)
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
        let dict = try dictionary ?? _getDict(data: data)
        if dict[PCText.name] != nil {
            try decoder.decode(PCText.self, from: data)
        } else if dict[PCStack.name] != nil {
            try decoder.decode(PCStack.self, from: data)
        } else if dict[PCScrollView.name] != nil {
            try decoder.decode(PCScrollView.self, from: data)
        } else if dict[PCShapeView.name] != nil {
            try decoder.decode(PCShapeView.self, from: data)
        } else if dict[PCAsyncImage.name] != nil {
            try decoder.decode(PCAsyncImage.self, from: data)
        } else if dict[PCButton.name] != nil {
            try decoder.decode(PCButton.self, from: data)
        } else if dict[PCOptionalView.name] != nil {
            try decoder.decode(PCOptionalView.self, from: data)
        }
    }

    static private func _getDict(data: Data) throws -> [String: AnyCodable] {
        try decoder.decode([String: AnyCodable].self, from: data)
    }
}
