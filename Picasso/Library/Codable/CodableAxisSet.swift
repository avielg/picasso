//
//  CodableAxisSet.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SwiftUI

extension Axis.Set: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let rawValue = try? container.decode(Int8.self) {
            self = Axis.Set(rawValue: rawValue)
        } else if let value = try? container.decode(String.self) {
            switch value {
            case "vertical": self = .vertical
            case "horizontal": self = .horizontal
            default: throw CodableError.decodeError(value: value)
            }
        } else if let values = try? container.decode([String].self) {
            switch values {
            case ["vertical", "horizontal"]: self = [.vertical, .horizontal]
            case ["vertical"]: self = .vertical
            case ["horizontal"]: self = .horizontal
            case []: self = []
            default: throw CodableError.decodeError(value: values.description)
            }
        } else {
            throw CodableError.decodeError(value: "Unknown value for Axis.Set")
        }
    }
}
