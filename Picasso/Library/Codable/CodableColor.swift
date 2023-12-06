//
//  CodableColor.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import SwiftUI

extension Color: Codable {
    func hexString() -> String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        return hexString
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .red: try "red".encode(to: encoder)
        case .orange: try "orange".encode(to: encoder)
        case .yellow: try "yellow".encode(to: encoder)
        case .green: try "green".encode(to: encoder)
        case .mint: try "mint".encode(to: encoder)
        case .teal: try "teal".encode(to: encoder)
        case .cyan: try "cyan".encode(to: encoder)
        case .blue: try "blue".encode(to: encoder)
        case .indigo: try "indigo".encode(to: encoder)
        case .purple: try "purple".encode(to: encoder)
        case .pink: try "pink".encode(to: encoder)
        case .brown: try "brown".encode(to: encoder)
        case .white: try "white".encode(to: encoder)
        case .gray: try "gray".encode(to: encoder)
        case .black: try "black".encode(to: encoder)
        case .clear: try "clear".encode(to: encoder)
        case .primary: try "primary".encode(to: encoder)
        case .secondary: try "secondary".encode(to: encoder)
        case .accentColor: try "accent".encode(to: encoder)
        default: try hexString().encode(to: encoder)
        }
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
