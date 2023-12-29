//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import SwiftUI

struct PCScrollView: PCView {
    static let names = ["scrollView"]

    private let axes: Axis.Set?
    private let scrollView: [AnyPCView]
    private let modifiers: PCModifiersData?

    var body: some View {
        ScrollView(axes ?? .vertical) {
            ForEach(scrollView.indices, id: \.self) {
                scrollView[$0]
            }
            .modifier(Parser.shared.modifiers(from: modifiers))
        }
    }

    init(
        _ axes: Axis.Set,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() },
        @PCViewBuilder views: () -> [AnyPCView]
    ) {
        self.scrollView = views()
        self.modifiers = modifiers().data()
        self.axes = axes
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(axes ?? .vertical, modifiers: modifiers, views: { scrollView })
    }

    /// TODO: This should work, but waiting for bug fix in Swift parameter packs implementation
//    init<each M: PCModifier>(axes: Axis.Set, views: [any PCView], modifier: repeat each M) {
//        self.scrollView = views
//        self.modifiers = [repeat AnyPCView((each modifier))].merged
//        self.axes = axes
//    }
}
