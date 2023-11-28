//
//  AsyncViewExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 28.11.2023.
//

import Foundation

let async_json1 = """
{
  "layout": { "axis": "ZStack" },
  "stack": [
    {
      "shape": { "type": { "rectangle": { "cornerRadius": 48 } } },
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
