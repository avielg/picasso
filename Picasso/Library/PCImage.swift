//
//  PCImage.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

extension ContentMode: AllCasesProvider {}

struct PCAsyncImage: View, Codable {
    let url: URL?
    let scale: CGFloat

    let mode: ContentMode?

    var body: some View {
        AsyncImage(url: url, scale: scale) { img in
            if let mode {
                img.resizable().aspectRatio(contentMode: mode)
            } else {
                img
            }
        } placeholder: {
            Color.clear
        }
    }
}

let image_json1 = """
{
  "_type": "Image",
  "url": "https://picsum.photos/100/200",
  "scale": 1,
}
"""

let image_json2 = """
{
  "_type": "Image",
  "url": "https://picsum.photos/200/400",
  "scale": 2,
}
"""

func imagesExample() -> some View {
    HStack {
        Parser.view(from: image_json1)
        Parser.view(from: image_json2)
    }
}

#Preview {
    imagesExample()
}