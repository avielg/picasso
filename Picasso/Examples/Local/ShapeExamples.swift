//
//  ShapeExample.swift
//  Picasso
//
//  Created by Aviel Gross on 19.11.2023.
//

import Foundation

let shape_json1 = """
{
  "_type": "Stack",
  "layout": { "axis": "VStack" },
  "views": [
    {
      "_type": "Shape",
      "shape": { "type": { "circle": { } } },
      "fill": { "color": { "value": "red" } },
      "stroke": { "color": { "value": "primary" } },
      "lineWidth": 3,
      "modifiers": [
        { "_type": "frame", "height": 32 },
      ],
    },
    {
      "_type": "Shape",
      "shape": { "type": { "rectangle": { "cornerRadius": 40 } } },
      "fill": { "color": { "value": "orange" } },
      "stroke": { "color": { "value": "teal" } },
      "lineWidth": 3,
      "modifiers": [
        { "_type": "frame", "minHeight": 50 },
      ],
    },
    {
      "_type": "Stack",
      "layout": { "axis": "ZStack" },
      "views": [
        {
          "_type": "Shape",
          "shape": { "type": { "capsule": { "style": "continuous" } } },
          "fill": { "gradient": {
            "gradient": [
              { "color": "blue", "location": 0 },
              { "color": "red", "location": 1 },
            ],
            "spread": { "linear": { "start": "leading", "end": "trailing" } }
          } },
          "modifiers": [
            { "_type": "frame", "width": 180 },
          ],
        },
        {
          "_type": "Text",
          "text": "Press Here!",
          "modifiers": [
            { "_type": "font", "font": { "weight": "bold", "style": "title" } },
            { "_type": "foregroundColor", "foregroundColor": "#432b8b66" }
          ]
        },
      ],
    }
  ],
}
"""
