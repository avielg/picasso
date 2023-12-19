//
//  ButtonExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import Foundation

let button_json1 = """
{
  "spacing": 32,
  "VStack": [
    {
      "button": "Show Sheet",
      "toggleFlag": "sheet1",
      "modifiers": {
        "foregroundColor": "orange",
        "font": { "weight": "bold" },
        "sheet": {
          "presentationFlag": "sheet1",
          "content": { 
            "VStack": [
              { 
                "text": "Hello!"
              },
              {
                "button": "Click me to dismiss!",
                "navigate": "dismiss"
              }
            ]
          }
        }
      }
    },
    {
      "button": "Does Nothing...",
      "toggleFlag": "does-nothing",
      "modifiers": {
        "foregroundColor": "purple",
        "font": { "weight": "bold" }
      }
    },
    {
      "button": "Open URL",
      "openURL": "https://www.apple.com",
      "modifiers": {
        "foregroundColor": "pink",
        "font": { "weight": "bold" }
      }
    },
    {
      "button": "Present URL",
      "presentURL": "https://www.apple.com",
      "modifiers": {
        "foregroundColor": "cyan",
        "font": { "weight": "bold" }
      }
    },
    {
      "optional": {
        "content": { "text": "Hi there! :)" },
        "presentationFlag": "show-text" }
    },
    {
      "button": "Shows Hidden Text",
      "toggleFlag": "show-text",
      "modifiers": {
        "foregroundColor": "teal",
        "font": { "weight": "bold" }
      }
    }
  ]
}
"""
