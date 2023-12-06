//
//  PCLayoutData+Layout.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCLayoutData {
    static func from(_ layout: any Layout) throws -> Self {
        if let vLayout = layout as? VStackLayout {

            return PCLayoutData(
                axis: .vStack,
                alignment: .from(Alignment(horizontal: vLayout.alignment, vertical: .center)),
                spacing: vLayout.spacing.map(Double.init)
            )
        } else if let hLayout = layout as? HStackLayout {
            return PCLayoutData(
                axis: .hStack,
                alignment: .from(Alignment(horizontal: .center, vertical: hLayout.alignment)),
                spacing: hLayout.spacing.map(Double.init)
            )
        } else if let zLayout = layout as? ZStackLayout {
            return PCLayoutData(
                axis: .zStack,
                alignment: .from(zLayout.alignment),
                spacing: 0
            )
        }
        throw CodableError.encodeError(value: layout)
    }
    
    var getSpacing: CGFloat? {
        if let spacing { CGFloat(spacing) }
        else { nil }
    }

    var toLayout: any Layout {
        let alignment = self.alignment ?? .center
        switch axis {
        case .vStack:
            return VStackLayout(alignment: alignment.toAlignment.horizontal, spacing: getSpacing)
        case .hStack:
            return HStackLayout(alignment: alignment.toAlignment.vertical, spacing: getSpacing)
        case .zStack:
            return ZStackLayout(alignment: alignment.toAlignment)
        }
    }
}
