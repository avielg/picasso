//
//  PCStack+View.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCStack: PCView {
    init(layout: any Layout, stack: [PCViewData], modifiers: PCModifiersData? = nil) throws {
        self.layout = try PCLayoutData.from(layout)
        self.stack = stack
        self.modifiers = modifiers
    }

    var body: some View {
        AnyLayout(layout.toLayout) {
            ForEach(stack) {
                Parser.view(from: $0)
            }
            .modifier(Parser.modifiers(from: modifiers))
        }
    }
}

func stackExample() -> some View {
    VStack {
        Text("STACK")
        Parser.view(from: stack_json1)
        Parser.view(from: stack_json2)
    }
}

struct PCStack_Previews: PreviewProvider {
    static var previews: some View {
        stackExample()
    }
}
