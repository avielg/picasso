//
//  Examples.swift
//  Picasso
//
//  Created by Aviel Gross on 15.11.2023.
//

import Foundation

let text_json1 = """
{
  "text": "Hello One",
  "modifiers": {
    "font": { "weight": "bold", "style": "title" },
    "padding": { "top": 30, "leading": 100 }
  }
}
"""

let text_json2 = """
{
  "text": "The Sony a7C II is the brand's second-generation compact rangefinder-style full-frame camera. Similar in design to Its predecessor, the a7C II uses the same fantastic 33MP BSI sensor from the larger Sony a7 IV and boasts impressive still, video and autofocus capabilities that should appeal to a wide range of users.",
  "modifiers": {
    "foregroundColor": "#A10D3C93",
    "lineLimit": [1,3],
    "alignment": "trailing"
  }
}
"""

let text_json3 = """
{
  "text": "Hello three",
  "modifiers": {
    "foregroundColor": "0x50a19a",
    "font": { "style": "title2", "weight": "ultralight" }
  }
}
"""

let text_json4 = """
{
  "text": "Hello four",
  "modifiers": {
    "foregroundColor": "orange",
    "font": { "style": "caption", "weight": "black", "design": "serif" }
  }
}
"""
