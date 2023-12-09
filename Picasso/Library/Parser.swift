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

    static func modifiers(from dictionary: PCModifiersData?) -> some PCModifier {
        do {
            return try _modifiers(from: dictionary)
        } catch {
            let scrollViewContent: [any PCView] = [
                PCText(
                    text: "Error parsing modifier data:",
                    modifiers: [
                        try! FontModifier(font: .title2.bold())
                            .jsonData().dictionary(),
                        try! ForegroundColorModifier(foregroundColor: .red)
                            .jsonData().dictionary()
                    ].merged
                ),
                PCText(
                    text: error.title,
                    modifiers: [
                        try! FontModifier(font: .body.bold())
                            .jsonData().dictionary(),
                        try! ForegroundColorModifier(foregroundColor: .red)
                            .jsonData().dictionary()
                    ].merged
                ),
                PCText(text: error.subtitle),
                PCText(text: error.debugDump),
                PCText(text: String(describing: dictionary ?? [:]))
            ]

            let sheetContent = PCScrollView(axes: .vertical, views: scrollViewContent, modifiers: [
                try! PaddingModifier(padding: .init(top: 8, leading: 6, bottom: 8, trailing: 6))
                    .jsonData().dictionary()
            ].merged)

            let buttonBackground = PCShapeView(
                shape: .rectangle(cornerRadius: 10),
                fill: .color(value: .red)
            )

            let modifiersValues: [Encodable] = [
                PaddingModifier(padding: .init(top: 4, leading: 4, bottom: 4, trailing: 4)),
                FrameModifier(frame: .init(width: 150, height: 60, minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: nil)),
                try! BackgroundModifier(content: buttonBackground),
                try! SheetModifier(presentationFlag: "modifier_error", content: sheetContent),
                ForegroundColorModifier(foregroundColor: .white)
            ]
            let modifiersData: [PCModifiersData] = modifiersValues.map { try! $0.jsonData().dictionary() }

            let button = PCButton(
                title: "Error parsing modifier data",
                action: .toggleFlag("modifier_error"),
                modifiers: modifiersData.merged
            )

            let errorContent = try! OverlayModifier(content: button).jsonData().dictionary()
            
            return try! _modifiers(from: errorContent)
        }
    }

    @ModifierBuilder
    private static func _modifiers(from dictionary: PCModifiersData?) throws -> some PCModifier {
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
    static private func _view(from data: Data, dictionary: [String: AnyCodable]? = nil) throws -> some View {
        let dict = try dictionary ?? _getDict(data: data)
        if dict.has(PCText.names) {
            try decoder.decode(PCText.self, from: data)
        } else if dict.has(PCStack.names) {
            try decoder.decode(PCStack.self, from: data)
        } else if dict.has(PCScrollView.names) {
            try decoder.decode(PCScrollView.self, from: data)
        } else if dict.has(PCShapeView.names) {
            try decoder.decode(PCShapeView.self, from: data)
        } else if dict.has(PCAsyncImage.names) {
            try decoder.decode(PCAsyncImage.self, from: data)
        } else if dict.has(PCButton.names) {
            try decoder.decode(PCButton.self, from: data)
        } else if dict.has(PCOptionalView.names) {
            try decoder.decode(PCOptionalView.self, from: data)
        } else if dict.has(PCAsyncView.names) {
            try decoder.decode(PCAsyncView.self, from: data)
        } else {
            let keys = try? dictionary?.keys.joined(separator: ", ") ?? data.dictionary().keys.joined(separator: ", ")
            throw CodableError.decodeError(value: "Unexpected view name keys: \(keys ?? "No keys")")
        }
    }

    static private func _getDict(data: Data) throws -> [String: AnyCodable] {
        try decoder.decode([String: AnyCodable].self, from: data)
    }
}

private extension [String : AnyCodable] {
    func has(_ anyOfKeys: [String]) -> Bool {
        keys.first { anyOfKeys.contains($0) } != nil
    }
}
