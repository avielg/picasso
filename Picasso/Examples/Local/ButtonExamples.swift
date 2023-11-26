//
//  ButtonExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import Foundation

let button_json1 = """
{
  "layout": { "axis": "VStack", "spacing": 32 },
  "stack": [
    {
      "button": "Click Here!",
      "actionToggleFlag": "sheet1",
      "modifiers": {
        "foregroundColor": "orange",
        "font": { "weight": "bold" },
        "sheet": {
          "presentationFlag": "sheet1",
          "content": { "text": "Hello!" }
        }
      }
    },
    {
      "button": "Does Nothing...",
      "actionToggleFlag": "does-nothing",
      "modifiers": {
        "foregroundColor": "purple",
        "font": { "weight": "bold" }
      }
    }
  ]
}
"""
