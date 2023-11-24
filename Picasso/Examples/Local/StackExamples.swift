//
//  StackExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 15.11.2023.
//

import Foundation

let stack_json1 = """
{
  "_type": "Stack",
  "layout": {
    "axis": "HStack",
    "spacing": 40
  },
  "views": [
    {
      "_type": "Text",
      "text": "Hello... "
    },
    {
      "_type": "Text",
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
  "_type": "Stack",
  "layout": {
    "axis": "HStack",
    "spacing": 32
  },
  "views": [
    {
      "_type": "Stack",
      "layout": {
        "axis": "VStack",
        "alignment": "leading"
      },
      "views": [
        { "_type": "Text", "text": "one", "fontWeight": "semibold" },
        { "_type": "Text", "text": "two" }
      ]
    },
    {
      "_type": "Stack",
      "layout": {
        "axis": "ZStack",
        "alignment": "bottomTrailing"
      },
      "views": [
        { "_type": "Text", "text": "one one one\\none one one" },
        { "_type": "Text", "text": "two", "foregroundColor": "red", "fontWeight": "black" }
      ]
    },
    {
      "_type": "Stack",
      "layout": {
        "axis": "HStack"
      },
      "views": [
        { "_type": "Text", "text": "one" },
        { "_type": "Text", "text": "two" }
      ]
    }
  ]
}
"""
