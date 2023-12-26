//
//  AnyPCView.swift
//  Picasso
//
//  Created by Aviel Gross on 09.12.2023.
//

import Foundation

struct AnyPCView: Codable {
    enum Kind: String, CodingKey {
        case hStack = "HStack"
        case vStack = "VStack"
        case zStack = "ZStack"
        case text, scrollView, shape, image, button, optional, url, color, pages
    }

    static let types: [(Kind, any PCView.Type)] = [
        (.text, PCText.self),
        (.hStack, PCStack.self),
        (.vStack, PCStack.self),
        (.zStack, PCStack.self),
        (.scrollView, PCScrollView.self),
        (.shape, PCShapeView.self),
        (.image, PCAsyncImage.self),
        (.button, PCButton.self),
        (.optional, PCOptionalView.self),
        (.url, PCAsyncView.self),
        (.color, PCColor.self),
        (.pages, PCPageView.self)
    ]

    let data: any PCView

    func encode(to encoder: Encoder) throws {
        try data.encode(to: encoder)
    }

    init(_ view: any PCView) {
        data = view
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Kind.self)

        let keys = container.allKeys
        if let (_, type) = Self.types.first(where: { keys.contains($0.0) }) {
            data = try type.init(from: decoder)
        } else {
            throw CodableError.decodeError(value: "Unexpected view name keys: \(container.allKeys)")
        }
    }
}
