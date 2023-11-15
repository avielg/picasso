//
//  PiText.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI
import AnyCodable

let text_json1 = """
{
  "_type": "Text",
  "text": "Hello One",
  "modifiers": [
    { "_type": "font", "font": { "weight": "bold", "style": "title" } }
  ]
}
"""

let text_json2 = """
{
  "_type": "Text",
  "text": "Hello two!",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "#A10D3C93" },
  ]
}
"""

let text_json3 = """
{
  "_type": "Text",
  "text": "Hello three",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "0x50a19a" },
    { "_type": "font", "font": { "style": "title2", "weight": "ultralight" } }
  ]
}
"""

let text_json4 = """
{
  "_type": "Text",
  "text": "Hello four",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "orange" },
    { "_type": "font", "font": { "style": "caption", "weight": "black", "design": "serif" } }
  ]
}
"""



func textExample() -> some View {
    VStack {
        Text("TEXT")
        Parser.view(from: text_json1)
        Parser.view(from: text_json2)
        Parser.view(from: text_json3)
        Parser.view(from: text_json4)
    }
}

struct PCText: View, Codable {
    enum Keys: CodingKey {
        case text, modifiers
    }

    let text: String
    let modifiersData: [PCModifierData]

    var body: some View {
        Text(text)
            .modifier(Parser.modifiers(from: modifiersData))
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.modifiersData = try container.decodeIfPresent([PCModifierData].self, forKey: .modifiers) ?? []
    }
}

enum CodableError: Error {
    case decodeError(value: String)
    case encodeError(value: Any)
}

extension Color: Codable {
    func hexString() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }

    public func encode(to encoder: Encoder) throws {
        try hexString().encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)
    
        if UIColor.isHexValue(rawValue) {
            self = Color(UIColor(hex: rawValue))
            return
        }

        switch rawValue {
        case "red": self = .red
        case "orange": self = .orange
        case "yellow": self = .yellow
        case "green": self = .green
        case "mint": self = .mint
        case "teal": self = .teal
        case "cyan": self = .cyan
        case "blue": self = .blue
        case "indigo": self = .indigo
        case "purple": self = .purple
        case "pink": self = .pink
        case "brown": self = .brown
        case "white": self = .white
        case "gray": self = .gray
        case "black": self = .black
        case "clear": self = .clear
        case "primary": self = .primary
        case "secondary": self = .secondary
        case "accent", "accentcolor", "accentColor": self = .accentColor
        default: throw CodableError.decodeError(value: rawValue)
        }
    }
}

/// https://stackoverflow.com/a/60141405/2242359
extension UIColor {
    static func isHexValue(_ value: String) -> Bool {
        value.firstMatch(of: /(#|0x)/) != nil
    }

    public convenience init(hex: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1

        var hexColor = hex
        hexColor.trimPrefix("#")
        hexColor.trimPrefix("0x")

        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        var valid = false

        if scanner.scanHexInt64(&hexNumber) {
            if hexColor.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                valid = true
            }
            else if hexColor.count == 6 {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat(hexNumber & 0x0000ff) / 255
                valid = true
            }
        }

        #if DEBUG
            assert(valid, "UIColor initialized with invalid hex string")
        #endif

        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension Font: Codable {
    enum Keys: CodingKey {
        case style, weight, design
    }

    private func modifier(from base: Any, weight: inout Font.Weight?, style: inout Font.TextStyle?, design: inout Font.Design?) -> Any? {

        var boxChildren = Mirror(reflecting: base).children
        while boxChildren.count == 1 {
            boxChildren = Mirror(reflecting: boxChildren.first!.value).children
        }
        if boxChildren.count > 1 {
            var base: Any?
            var modifier: Any?
            for child in boxChildren {
                if child.label == "base" {
                    base = child.value
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
                    print(child.label, child.value)
                }
            }

            if let modifierData = Mirror(reflecting: modifier).children.first {
                let modifierValueData = Mirror(reflecting: modifierData.value).children.first!
                if let weightValue = modifierValueData.value as? Font.Weight {
                    weight = weightValue
                } else {
                    print(modifierValueData.value)
                }
            }

            return base
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
        try container.encode(weightData ?? .regular, forKey: .weight)
        try container.encode(styleData ?? .body, forKey: .style)
        try container.encode(designData ?? .default, forKey: .design)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let style = try container.decodeIfPresent(Font.TextStyle.self, forKey: .style) ?? .body
        let weight = try container.decodeIfPresent(Font.Weight.self, forKey: .weight) ?? .regular
        let design = try container.decodeIfPresent(Font.Design.self, forKey: .design) ?? .default
        self = .system(style, design: design, weight: weight)
    }
}

extension Font.TextStyle: Codable {
    public func encode(to encoder: Encoder) throws {
        try "\(self)".encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)
        let value = Self.allCases.first { "\($0)" == rawValue }
        if let value {
            self = value
        } else {
            throw CodableError.decodeError(value: rawValue)
        }
    }
}

extension Font.Design: Codable {
    public func encode(to encoder: Encoder) throws {
        try "\(self)".encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)

        switch rawValue {
        case "default": self = .default
        case "serif": self = .serif
        case "rounded": self = .rounded
        case "monospaced": self = .monospaced
        default: throw CodableError.decodeError(value: rawValue)
        }
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

#Preview {
    textExample()
}
