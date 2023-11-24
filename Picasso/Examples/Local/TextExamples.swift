//
//  Examples.swift
//  Picasso
//
//  Created by Aviel Gross on 15.11.2023.
//

import Foundation

let text_json1 = """
{
  "_type": "Text",
  "text": "Hello One",
  "modifiers": [
    { "_type": "font", "font": { "weight": "bold", "style": "title" } },
    { "_type": "padding", "top": 30, "leading": 100 }
  ]
}
"""

let text_json2 = """
{
  "_type": "Text",
  "text": "The Sony a7C II is the brand's second-generation compact rangefinder-style full-frame camera. Similar in design to Its predecessor, the a7C II uses the same fantastic 33MP BSI sensor from the larger Sony a7 IV and boasts impressive still, video and autofocus capabilities that should appeal to a wide range of users.",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "#A10D3C93" },
    { "_type": "lineLimit", "range": [1,3] },
    { "_type": "alignment", "alignment": "trailing" }
  ]
}
"""

let text_json3 = """
{
  "_type": "Text",
  "text": "Hello three",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "0x50a19a" },
    { "_type": "font", "font": { "style": "title2", "weight": "ultralight" } }
  ]
}
"""

let text_json4 = """
{
  "_type": "Text",
  "text": "Hello four",
  "modifiers": [
    { "_type": "foregroundColor", "foregroundColor": "orange" },
    { "_type": "font", "font": { "style": "caption", "weight": "black", "design": "serif" } }
  ]
}
"""
