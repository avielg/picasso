//
//  ShapeExample.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import SwiftUI

func shapesExample() -> some View {
    VStack {
        Parser.shared.view(from: shape_json1)
    }
}

#Preview {
    shapesExample()
}

let shape_json1 = """
{
  "VStack": [
    {
      "shape": { "circle": { } },
      "fill": { "color": { "value": "red" } },
      "stroke": { "color": { "value": "primary" } },
      "lineWidth": 3,
      "modifiers": {
        "frame": { "height": 32 }
      }
    },
    {
      "shape": { "rectangle": { "cornerRadius": 40 } },
      "fill": { "color": { "value": "orange" } },
      "stroke": { "color": { "value": "teal" } },
      "lineWidth": 3,
      "modifiers": {
        "frame": { "minHeight": 50 }
      }
    },
    {
      "text": "background...",
      "modifiers": {
        "font": { "weight": "bold", "style": "title" },
        "foregroundColor": "#432b8b66",
        "padding": { "top": 4, "bottom": 4, "leading": 28, "trailing": 28 },
        "background": {
          "content": {
            "shape": { "capsule": { "style": "continuous" } },
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
    },
    {
      "shape": { "capsule": { "style": "continuous" } },
      "fill": { "gradient": {
        "gradient": [
          { "color": "blue", "location": 0 },
          { "color": "red", "location": 1 }
        ],
        "spread": { "linear": { "start": "leading", "end": "trailing" } }
      } },
      "modifiers": {
        "frame": { "height": 42 },
        "overlay": {
          "alignment": "bottomTrailing",
          "content": { 
            "text": "overlay at bottomTrailing...",
            "modifiers": {
              "padding": { "top": 4, "bottom": 4, "leading": 28, "trailing": 28 }
            }
          }
        }
      }
    },
    {
      "alignment": "topLeading",
      "ZStack": [
        {
          "shape": { "capsule": { "style": "continuous" } },
          "fill": { "gradient": {
            "gradient": [
              { "color": "blue", "location": 0 },
              { "color": "red", "location": 1 }
            ],
            "spread": { "linear": { "start": "leading", "end": "trailing" } }
          } }
        },
        { 
          "text": "ZStack...",
          "modifiers": {
            "padding": { "top": 4, "bottom": 4, "leading": 28, "trailing": 28 }
          }
        }
      ]
    }
  ]
}
"""
