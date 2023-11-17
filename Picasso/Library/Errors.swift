//
//  Errors.swift
//  Picasso
//
//  Created by Aviel Gross on 17.11.2023.
//

import Foundation

extension Error {
    var debugDump: String {
        var value: String = ""
        dump(self, to: &value)
        return value
    }

    var title: String {
        if let codableError = self as? CodableError {
            codableError.title
        } else if let decodingError = self as? DecodingError {
            decodingError.title
        } else {
            "Error"
        }
    }

    var subtitle: String {
        if let codableError = self as? CodableError {
            switch codableError {
            case .decodeError(let value): return "\(value)"
            case .encodeError(let value): return "\(value)"
            }
        }
        if
            let underlyingError = (self as NSError).underlyingErrors.first as? NSError,
            let description = underlyingError.userInfo["NSDebugDescription"] as? String
        {
            return description
        }
        return localizedDescription
    }

    var description: String {
        if self is CodableError { return "" }
        return debugDump
    }
}

extension CodableError {
    var title: String {
        switch self {
        case .decodeError: return "Decode Error"
        case .encodeError: return "Encode Error"
        }
    }
}

extension DecodingError {
    var title: String {
        switch self {
        case .typeMismatch(let any, _): "Type mismatch: \(any)"
        case .valueNotFound(let any, _): "Value not found: \(any)"
        case .keyNotFound(let codingKey, _): "Key not found: \(codingKey)"
        case .dataCorrupted: "Data corrupted"
        default: debugDump
        }
    }
}

extension Error {
    var viewJSONData: Data {
        viewJSONPayload.data(using: .utf8)!
    }

    var viewJSONPayload: String {
        let escape: (String) -> String = {
            $0
                .replacingOccurrences(of: "\\\"", with: "\"")
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "\n", with: "\\n")
        }

        return """
        {
          "_type": "Stack",
          "layout": {
            "axis": "VStack",
            "alignment": "leading"
          },
          "views": [
            {
              "_type": "Text",
              "text": "\(title)",
              "modifiers": [
                { "_type": "font", "font": { "style": "callout", "weight": "bold" } },
                { "_type": "foregroundColor", "foregroundColor": "red" }
              ],
            },
            {
              "_type": "Text",
              "text": "\(escape(subtitle))",
              "modifiers": [
                { "_type": "font", "font": { "style": "callout", "weight": "regular" } },
                { "_type": "foregroundColor", "foregroundColor": "red" }
              ],
            },
            {
              "_type": "Text",
              "text": "\(escape(description))",
              "modifiers": [
                { "_type": "font", "font": { "style": "footnote" } },
                { "_type": "foregroundColor", "foregroundColor": "red" }
              ],
            }
          ]
        }
        """
    }
}