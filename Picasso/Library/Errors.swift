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
          "alignment": "leading",
          "VStack": [
            {
              "text": "\(title)",
              "modifiers": {
                "font": { "style": "callout", "weight": "bold" },
                "foregroundColor": "red"
              }
            },
            {
              "text": "\(escape(subtitle))",
              "modifiers": {
                "font": { "style": "callout", "weight": "regular" },
                "foregroundColor": "red"
              }
            },
            {
              "text": "\(escape(description))",
              "modifiers": {
                "font": { "style": "footnote" },
                "foregroundColor": "red"
              }
            }
          ]
        }
        """
    }
}

// swiftlint:disable force_try
extension Error {

    @PCViewBuilder
    func scrollViewContent(extraInfo: String) -> [AnyPCView] {
        PCText("Error parsing modifier data:")
            .modifiers {
                FontModifier(.title2.bold())
                ForegroundColorModifier(.red)
            }
        PCText(title)
            .modifiers {
                FontModifier(.body.bold())
                ForegroundColorModifier(.red)
            }
        PCText(subtitle)
        PCText(debugDump)
        PCText(extraInfo)
    }

    func modifierData(extraInfo: String) -> PCModifiersData {
        let sheetContent = PCScrollView(.vertical) {
            scrollViewContent(extraInfo: extraInfo)
        }
            .modifiers {
                PaddingModifier(.init(top: 8, leading: 6, bottom: 8, trailing: 6))
            }


        let buttonBackground = PCShapeView(
            .rectangle(cornerRadius: 10),
            fill: .color(value: .red)
        )

        let button = PCButton(
            "Error parsing modifier data",
            action: .toggleFlag("modifier_error")
        ) {
            PaddingModifier(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            FrameModifier(.init(width: 150, height: 60, minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: nil))
            BackgroundModifier(buttonBackground)
            SheetModifier(presentationFlag: "modifier_error", content: sheetContent)
            ForegroundColorModifier(.white)
        }

        let errorContent = OverlayModifier(button)
        return errorContent.data()
    }
}
