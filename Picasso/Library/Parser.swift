//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI

protocol PCView: View, Codable {
    static var names: [String] { get }
}

extension Encodable {
    func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

extension Data {
    func dictionary() throws -> [String: AnyCodable] {
        try JSONDecoder().decode([String: AnyCodable].self, from: self)
    }
}

extension [PCModifiersData] {
    var merged: PCModifiersData {
        var result = PCModifiersData()
        for dict in self {
            for (key, value) in dict {
                result[key] = value
            }
        }
        return result
    }
}

public protocol SomeEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable
}

public protocol SomeDecoder {
    func decode<T : Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: SomeDecoder {}
extension JSONEncoder: SomeEncoder {}

// swiftlint:disable force_try
public class Parser {
    internal var encoder: SomeEncoder
    internal var decoder: SomeDecoder

    public init(encoder: SomeEncoder, decoder: SomeDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }

    func view(from json: String) -> AnyPCView {
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

    func view(from data: Data) -> AnyPCView {
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

    func modifiers(from dictionary: PCModifiersData?) -> some PCModifier {
        do {
            return try _modifiers(from: dictionary)
        } catch {
            let errorData = error.modifierData(
                extraInfo: String(describing: dictionary ?? [:])
            )
            return try! _modifiers(from: errorData)
        }
    }

    @ModifierBuilder
    private func _modifiers(from dictionary: PCModifiersData?) throws -> some PCModifier {
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
            if dictionary[OverlayModifier.name] != nil {
                try decoder.decode(OverlayModifier.self, from: data)
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
    private func _view(from data: Data) throws -> AnyPCView {
        try decoder.decode(AnyPCView.self, from: data)
    }
}
