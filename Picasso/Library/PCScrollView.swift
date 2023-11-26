//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
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

struct PCScrollView: PCView {
    static var name: String { "scrollView" }

    private let axes: Axis.Set?
    private let scrollView: [PCViewData]
    private let modifiers: PCModifiersData?

    var body: some View {
        ScrollView(axes ?? .vertical) {
            ForEach(scrollView) {
                Parser.view(from: $0)
            }
            .modifier(try! Parser.modifiers(from: modifiers))
        }
    }

    init(axes: Axis.Set, views: [PCViewData], modifiers: PCModifiersData? = nil) {
        self.scrollView = views
        self.modifiers = modifiers
        self.axes = axes
    }
}

#Preview {
    Parser.view(from: scrollview_example1)
}
