//
//  PCScrollView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import SwiftUI

struct PCScrollView: View, Codable {
    private let views: [PCViewData]

    var body: some View {
        ScrollView {
            ForEach(views) {
                Parser.view(from: $0)
            }
        }
    }

    init(views: [PCViewData]) {
        self.views = views
    }
}

#Preview {
    Parser.view(from: scrollview_example1)
}
