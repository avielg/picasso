//
//  CustomFont.swift
//  Picasso
//
//  Created by Aviel Gross on 20.12.2023.
//

import SwiftUI

enum CustomFont {
    static var weights = [Font.Weight: String]()
}

extension View {
    public func font(
        _ style: Font.TextStyle? = nil,
        weight: Font.Weight? = nil,
        design: Font.Design? = nil
    ) -> some View {
        let style = style ?? .body
        return self
             .font(
                CustomFont.weights[weight ?? .regular].map {
                    Font.custom($0, size: style.pointSize, relativeTo: style)
                }
                ?? 
                .system(.headline, design: design, weight: weight ?? Font.Weight(style))
            )
    }
}

private extension Font.Weight {
    /// Returns non-regular weight for ``style``, or `nil` if weight is ``Font.Weight.regular``
    init?(_ style: Font.TextStyle) {
        switch style {
        case .headline: self = .semibold
        case .extraLargeTitle: self = .bold
        case .extraLargeTitle2: self = .bold
        default: return nil
        }
    }
}

private extension Font.TextStyle {
    var pointSize: CGFloat {
        switch self {
        case .extraLargeTitle: 36
        case .extraLargeTitle2: 28
        case .largeTitle: 34
        case .title: 28
        case .title2: 22
        case .title3: 20
        case .headline: 17
        case .subheadline: 15
        case .body: 17
        case .callout: 16
        case .footnote: 13
        case .caption: 12
        case .caption2: 11
        @unknown default: Self.body.pointSize
        }
    }
}
