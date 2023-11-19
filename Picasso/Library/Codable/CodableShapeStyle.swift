//
//  CodableShapeStyle.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

extension Gradient.Stop: Codable {
    enum Keys: CodingKey { case color, location }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(color, forKey: .color)
        try container.encode(location, forKey: .location)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        let color = try container.decode(Color.self, forKey: .color)
        let location = try container.decode(CGFloat.self, forKey: .location)
        self.init(color: color, location: location)
    }
}

extension Gradient: Codable {
    public func encode(to encoder: Encoder) throws {
        try stops.encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        let stops = try [Gradient.Stop].init(from: decoder)
        self.init(stops: stops)
    }
}

extension RoundedCornerStyle: AllCasesProvider {
    static var allCases: [RoundedCornerStyle] {
        [.circular, .continuous]
    }
}

extension UnitPoint: Codable {
    public func encode(to encoder: Encoder) throws {
        let rawValue = switch self {
        case .zero: "zero"
        case .center: "center"
        case .leading: "leading"
        case .trailing: "trailing"
        case .top: "top"
        case .bottom: "bottom"
        case .topLeading: "topLeading"
        case .topTrailing: "topTrailing"
        case .bottomLeading: "bottomLeading"
        case .bottomTrailing: "bottomTrailing"
        default: throw CodableError.decodeError(value: "\(self)")
        }
        try rawValue.encode(to: encoder)
    }

    public init(from decoder: Decoder) throws {
        let rawValue = try String(from: decoder)

        switch rawValue {
        case "zero": self = .zero
        case "center": self = .center
        case "leading": self = .leading
        case "trailing": self = .trailing
        case "top": self = .top
        case "bottom", "semiBold": self = .bottom
        case "topLeading": self = .topLeading
        case "topTrailing": self = .topTrailing
        case "bottomLeading": self = .bottomLeading
        case "bottomTrailing": self = .bottomTrailing
        default: throw CodableError.decodeError(value: rawValue)
        }
    }
}

enum GradientSpread: Codable {
    typealias Degrees = CGFloat
    case linear(start: UnitPoint, end: UnitPoint)
    case angular(center: UnitPoint, startAngle: Degrees = .zero, endAngle: Degrees = .zero)
    case elliptical(center: UnitPoint, startRadiusFraction: CGFloat = 0, endRadiusFraction: CGFloat = 0.5)
    case radial(center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
}

enum ShapePaint: Codable {
    case color(value: Color)
    case gradient(gradient: Gradient, spread: GradientSpread)

    var content: AnyShapeStyle {
        switch self {
        case .color(let color):
            AnyShapeStyle(color)
        case .gradient(let gradient, let spread):
            switch spread {
            case .linear(let start, let end):
                AnyShapeStyle(
                    LinearGradient(gradient: gradient, startPoint: start, endPoint: end)
                )
            case .angular(let center, let startAngle, let endAngle):
                AnyShapeStyle(
                    AngularGradient(gradient: gradient, center: center, startAngle: .init(degrees: startAngle), endAngle: .init(degrees: endAngle))
                )
            case .elliptical(let center, let startRadiusFraction, let endRadiusFraction):
                AnyShapeStyle(
                    EllipticalGradient(gradient: gradient, center: center, startRadiusFraction: startRadiusFraction, endRadiusFraction: endRadiusFraction)
                )
            case .radial(let center, let startRadius, let endRadius):
                AnyShapeStyle(
                    RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
                )
            }
        }
    }
}
