//
//  PageExamples.swift
//  Picasso
//
//  Created by Aviel Gross on 26.12.2023.
//

import Foundation

func pagesExample() -> some PCView {
    PCPageView {
        PCAsyncImage(URL(string: "https://picsum.photos/200/300"))
        PCAsyncImage(URL(string: "https://picsum.photos/200/300"))
        PCAsyncImage(URL(string: "https://picsum.photos/200/300"))
    }
    .modifiers {
        BackgroundModifier(PCColor(.black))
        FontModifier(.headline)
    }
}
