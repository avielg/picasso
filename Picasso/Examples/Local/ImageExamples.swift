//
//  ImageExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 24.11.2023.
//

import SwiftUI

func imagesExample() -> some View {
    HStack {
        Parser.shared.view(from: image_json1)
        Parser.shared.view(from: image_json2)
    }
}

#Preview {
    imagesExample()
}

let image_json1 = """
{
  "image": "https://picsum.photos/100/200",
  "scale": 1
}
"""

let image_json2 = """
{
  "image": "https://picsum.photos/200/400",
  "scale": 2
}
"""
