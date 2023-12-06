//
//  CodableAlignment.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension Alignment: Codable {
    public func encode(to encoder: Encoder) throws {
        let rawValue = switch self {
        case .center: "center"
        case .leading: "leading"
        case .trailing: "trailing"
        case .top: "top"
        case .bottom: "bottom"
        case .topLeading: "topLeading"
        case .topTrailing: "topTrailing"
        case .bottomLeading: "bottomLeading"
        case .bottomTrailing: "bottomTrailing"
        case self where horizontal == .listRowSeparatorLeading: "listRowSeparatorLeading"
        case self where horizontal == .listRowSeparatorTrailing: "listRowSeparatorTrailing"
        case self where vertical == .firstTextBaseline: "firstTextBaseline"
        case self where vertical == .lastTextBaseline: "lastTextBaseline"
        default: throw CodableError.decodeError(value: "\(self)")
        }
        try rawValue.encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)

        switch rawValue {
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        case "listRowSeparatorLeading": self = .init(horizontal: .listRowSeparatorLeading, vertical: .center)
        case "listRowSeparatorTrailing": self = .init(horizontal: .listRowSeparatorTrailing, vertical: .center)
        case "firstTextBaseline": self = .init(horizontal: .center, vertical: .firstTextBaseline)
        case "lastTextBaseline": self = .init(horizontal: .center, vertical: .lastTextBaseline)
        default: throw CodableError.decodeError(value: rawValue)
        }
    }
}
