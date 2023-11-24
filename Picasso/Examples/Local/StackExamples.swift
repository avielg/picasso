//
//  StackExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 15.11.2023.
//

import Foundation

let stack_json1 = """
{
  "layout": {
    "axis": "HStack",
    "spacing": 40
  },
  "stack": [
    {
      "text": "Hello... "
    },
    {
      "text": "...world"
    }
  ],
  "modifiers": {
    "foregroundColor": "#306ff6"
  }
}
"""

let stack_json2 = """
{
  "layout": {
    "axis": "HStack",
    "spacing": 32
  },
  "stack": [
    {
      "layout": {
        "axis": "VStack",
        "alignment": "leading"
      },
      "stack": [
        { "text": "one", "fontWeight": "semibold" },
        { "text": "two" }
      ]
    },
    {
      "layout": {
        "axis": "ZStack",
        "alignment": "bottomTrailing"
      },
      "stack": [
        { "text": "one one one\\none one one" },
        { "text": "two", "foregroundColor": "red", "fontWeight": "black" }
      ]
    },
    {
      "layout": {
        "axis": "HStack"
      },
      "stack": [
        { "text": "one" },
        { "text": "two" }
      ]
    }
  ]
}
"""
