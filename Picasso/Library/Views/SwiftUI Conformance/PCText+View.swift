//
//  PCText+View.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCText: PCView {
    var body: some View {
        Text(text)
            .modifier(Parser.modifiers(from: modifiers))
    }
}

func textExample() -> some View {
    VStack {
        Text("TEXT")
        Parser.view(from: text_json1)
        Parser.view(from: text_json2)
        Parser.view(from: text_json3)
        Parser.view(from: text_json4)
    }
}

struct PCText_Previews: PreviewProvider {
    static var previews: some View {
        textExample()
    }
}