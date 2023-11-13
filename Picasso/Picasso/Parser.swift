//
//  Parser.swift
//  Picasso
//
//  Created by Aviel Gross on 12.11.2023.
//

import AnyCodable
import SwiftUI

enum Parser {
    static func view(from json: String) -> some View {
        let data = json.data(using: .utf8)!
        return _view(from: data)
    }

    static func view(from dictionary: [String: AnyCodable]) -> some View {
        let encoder = JSONEncoder()
        let json = try! encoder.encode(dictionary)
        return _view(from: json, dictionary: dictionary)
    }

    ///
    /// # Option 1: ViewBuilder with all options in the type
    ///
    
    @ViewBuilder
    static func _view(from data: Data, dictionary: [String: AnyCodable]? = nil) -> some View {
        switch _getTypeName(data: data, dictionary: dictionary) {
        case "Text": try! JSONDecoder().decode(PCText.self, from: data)
        case "Stack": try! JSONDecoder().decode(PCStack.self, from: data)
        default: fatalError()
        }
    }

    static private func _getTypeName(data: Data, dictionary: [String: AnyCodable]?) -> String {
        let jsonObj: [String: AnyCodable]
        if let dictionary {
            jsonObj = dictionary
        } else {
            let decoder = JSONDecoder()
            jsonObj = try! decoder.decode([String: AnyCodable].self, from: data)
        }

        return jsonObj["_type"]!.value as! String
    }

    ///
    /// # Option 2: Erase with AnyView
    ///

//    static func _view(from data: Data) -> some View {
//        let decoder = JSONDecoder()
//        let jsonObj = try! decoder.decode([String: AnyDecodable].self, from: data)
//
//        let type = viewType(for: jsonObj["_type"]!.value as! String)
//
//        let view = try! JSONDecoder().decode(type, from: data) as! any View
//        return AnyView(view)
//    }
//
//    static func viewType(for typeName: String) -> Decodable.Type {
//        switch typeName {
//        case "Text": return PCText.self
//        case "Stack": return PCStack.self
//        default: fatalError()
//        }
//    }

}
