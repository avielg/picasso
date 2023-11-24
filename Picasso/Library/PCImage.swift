//
//  PCImage.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

extension ContentMode: AllCasesProvider {}

struct PCAsyncImage: View, Codable {
    private let image: URL?
    private let scale: CGFloat?
    private let mode: ContentMode?

    private let modifiers: PCModifiersData?

    var body: some View {
        AsyncImage(url: image, scale: scale ?? 1, transaction: .init(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                if let mode {
                    image.resizable().aspectRatio(contentMode: mode)
                } else {
                    image
                }
            default:
                Color.clear
            }
        }
        .modifier(try! Parser.modifiers(from: modifiers))
    }

    init(image: URL?, scale: CGFloat?, mode: ContentMode?, modifiers: PCModifiersData?) {
        self.image = image
        self.scale = scale
        self.mode = mode
        self.modifiers = modifiers
    }
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

func imagesExample() -> some View {
    HStack {
        Parser.view(from: image_json1)
        Parser.view(from: image_json2)
    }
}

#Preview {
    imagesExample()
}
