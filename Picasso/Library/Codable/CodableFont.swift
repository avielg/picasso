//
//  CodableFont.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import SwiftUI

extension Font: Codable {
    enum Keys: CodingKey {
        case style, weight, design
    }

    private func modifier(from base: Any, weight: inout Font.Weight?, style: inout Font.TextStyle?, design: inout Font.Design?) -> Any? {

        var boxChildren = Mirror(reflecting: base).children
        while boxChildren.count == 1 {
            let value = boxChildren.first!.value
            if "\(type(of: value))".contains("<BoldModifier>") {
                weight = .bold
            }
            boxChildren = Mirror(reflecting: boxChildren.first!.value).children
        }
        if boxChildren.count > 1 {
            var nextBase: Any?
            var modifier: Any?
            for child in boxChildren {
                if child.label == "base" {
                    nextBase = child.value
                } else if child.label == "modifier" {
                    modifier = child.value
                } else if let styleValue = child.value as? Font.TextStyle {
                    style = styleValue
                } else if let designValue = child.value as? Font.Design {
                    design = designValue
                } else if let weightValue = child.value as? Font.Weight {
                    weight = weightValue
                } else if ["design", "weight", "style"].contains(child.label) {
                    // noop - value for this is likely nil
                } else {
                    assertionFailure("Unknown child -> \(child.label ?? "No Label"): \(child.value)")
                }
            }
            
            if let modifier, let modifierData = Mirror(reflecting: modifier).children.first {
                if let weightValue = modifierData.value as? Font.Weight {
                    weight = weightValue
                } else {
                    let modifierValueData = Mirror(reflecting: modifierData.value).children.first!
                    if let weightValue = modifierValueData.value as? Font.Weight {
                        weight = weightValue
                    } else {
                        print(modifierValueData.value)
                    }
                }
            }

            return nextBase
        }
        return nil
    }

    public func encode(to encoder: Encoder) throws {
        var weightData: Font.Weight?
        var styleData: Font.TextStyle?
        var designData: Font.Design?

        var nextBase: Any? = self
        while let base = nextBase {
            nextBase = modifier(from: base, weight: &weightData, style: &styleData, design: &designData)
        }

        var container = encoder.container(keyedBy: Keys.self)
        if let weightData, weightData != .regular {
            try container.encode(weightData, forKey: .weight)
        }
        if let styleData, styleData != .body {
            try container.encode(styleData, forKey: .style)
        }
        if let designData, designData != .default {
            try container.encode(designData, forKey: .design)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let style = try container.decodeIfPresent(Font.TextStyle.self, forKey: .style) ?? .body
        let weight = try container.decodeIfPresent(Font.Weight.self, forKey: .weight) ?? .regular
        let design = try container.decodeIfPresent(Font.Design.self, forKey: .design) ?? .default
        self = .system(style, design: design, weight: weight)
    }
}

extension Font.TextStyle: AllCasesProvider {}

extension Font.Design: AllCasesProvider {
    static var allCases: [Font.Design] {
        [.default, .serif, .rounded, .monospaced]
    }
}

extension Font.Weight: Codable {
    public func encode(to encoder: Encoder) throws {
        let rawValue = switch self {
        case .ultraLight: "ultraLight"
        case .thin: "thin"
        case .light: "light"
        case .regular: "regular"
        case .medium: "medium"
        case .semibold: "semibold"
        case .bold: "bold"
        case .heavy: "heavy"
        case .black: "black"
        default: throw CodableError.decodeError(value: "\(self)")
        }
        try rawValue.encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)

        switch rawValue {
        case "ultraLight", "ultralight": self = .ultraLight
        case "thin": self = .thin
        case "light": self = .light
        case "regular": self = .regular
        case "medium": self = .medium
        case "semibold", "semiBold": self = .semibold
        case "bold": self = .bold
        case "heavy": self = .heavy
        case "black": self = .black
        default: throw CodableError.decodeError(value: rawValue)
        }
    }
}
