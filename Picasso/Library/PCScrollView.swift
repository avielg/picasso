//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import SwiftUI

struct PCScrollView: PCView {
    static var name: String { "scrollView" }

    private let scrollView: [PCViewData]
    private let modifiers: PCModifiersData?

    var body: some View {
        ScrollView {
            ForEach(scrollView) {
                Parser.view(from: $0)
            }
            .modifier(try! Parser.modifiers(from: modifiers))
        }
    }

    init(views: [PCViewData], modifiers: PCModifiersData? = nil) {
        self.scrollView = views
        self.modifiers = modifiers
    }
}

#Preview {
    Parser.view(from: scrollview_example1)
}
