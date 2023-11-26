//
//  PCButton.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SwiftUI

struct PCButton: PCView {
    static var name: String { "button" }

    private let button: String
    private let actionToggleFlag: String

    private let modifiers: PCModifiersData?

    var body: some View {
        Button(button) {
            Context.shared.flag(actionToggleFlag).value.toggle()
        }
        .modifier(try! Parser.modifiers(from: modifiers))
    }
}
