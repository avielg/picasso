//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import SwiftUI

struct PCScrollView: View, Codable {
    private let views: [PCViewData]
    private let modifiers: [PCModifierData]?

    var body: some View {
        ScrollView {
            ForEach(views) {
                Parser.view(from: $0)
            }
            .modifier(try! Parser.modifiers(from: modifiers ?? []))
        }
    }

    init(views: [PCViewData], modifiers: [PCModifierData]? = nil) {
        self.views = views
        self.modifiers = modifiers
    }
}

#Preview {
    Parser.view(from: scrollview_example1)
}
