//
//  StackExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 15.11.2023.
//

import SwiftUI

func stackExample() -> some View {
    VStack {
        Text("STACK")
        Parser.shared.view(from: stack_json1)
        Parser.shared.view(from: stack_json2)
    }
}

struct PCStack_Previews: PreviewProvider {
    static var previews: some View {
        stackExample()
    }
}

let stack_json1 = """
{
  "spacing": 40,
  "HStack": [
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
  "spacing": 32,
  "HStack": [
    {
      "alignment": "leading",
      "VStack": [
        { "text": "one", "fontWeight": "semibold" },
        { "text": "two" }
      ]
    },
    {
      "alignment": "bottomTrailing",
      "ZStack": [
        { "text": "one one one\\none one one" },
        { "text": "two", "foregroundColor": "red", "fontWeight": "black" }
      ]
    },
    {
      "HStack": [
        { "text": "one" },
        { "text": "two" }
      ]
    }
  ]
}
"""
