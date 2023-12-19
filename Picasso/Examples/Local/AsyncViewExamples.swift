//
//  AsyncViewExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 28.11.2023.
//

import SwiftUI

func asyncExamples() -> some View {
    Parser.shared.view(from: async_json1)
}

let async_json1 = """
{
  "ZStack": [
    {
      "shape": { "rectangle": { "cornerRadius": 48 } },
      "fill": { "color": { "value": "orange" } }
    },
    {
      "url": "https://f001.backblazeb2.com/file/Picasso/Example.json",
      "modifiers": {
        "padding": { "top": 10, "bottom": 10, "leading": 10, "trailing": 10 }
      }
    }
  ]
}
"""
