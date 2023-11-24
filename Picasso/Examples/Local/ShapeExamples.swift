//
//  ShapeExample.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import Foundation

let shape_json1 = """
{
  "layout": { "axis": "VStack" },
  "stack": [
    {
      "shape": { "type": { "circle": { } } },
      "fill": { "color": { "value": "red" } },
      "stroke": { "color": { "value": "primary" } },
      "lineWidth": 3,
      "modifiers": {
        "frame": { "height": 32 }
      }
    },
    {
      "shape": { "type": { "rectangle": { "cornerRadius": 40 } } },
      "fill": { "color": { "value": "orange" } },
      "stroke": { "color": { "value": "teal" } },
      "lineWidth": 3,
      "modifiers": {
        "frame": { "minHeight": 50 }
      }
    },
    {
      "text": "Press Here!",
      "modifiers": {
        "font": { "weight": "bold", "style": "title" },
        "foregroundColor": "#432b8b66",
        "padding": { "top": 4, "bottom": 4, "leading": 28, "trailing": 28 },
        "background": {
          "content": {
            "shape": { "type": { "capsule": { "style": "continuous" } } },
            "fill": { "gradient": {
              "gradient": [
                { "color": "blue", "location": 0 },
                { "color": "red", "location": 1 }
              ],
              "spread": { "linear": { "start": "leading", "end": "trailing" } }
            } }
          }
        }
      }
    }
  ]
}
"""
