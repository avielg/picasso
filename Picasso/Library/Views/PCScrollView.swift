//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import SwiftUI

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
