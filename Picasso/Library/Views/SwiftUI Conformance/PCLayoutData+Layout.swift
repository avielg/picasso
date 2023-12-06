//
//  PCLayoutData+Layout.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCLayoutData {
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
