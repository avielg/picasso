//
//  CodableConformance.swift
//  Picasso
//
//  Created by Aviel Gross on 14.11.2023.
//

import SwiftUI

enum CodableError: Error {
    case decodeError(value: String)
    case encodeError(value: Any)
}

protocol AllCasesProvider: Codable {
    static var allCases: [Self] { get }
}

extension AllCasesProvider {
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

extension TextAlignment: AllCasesProvider {}
