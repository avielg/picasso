//
//  PCViewBuilder.swift
//  Picasso
//
//  Created by Aviel Gross on 26.12.2023.
//

import Foundation

@resultBuilder
struct PCViewBuilder {

    static func buildPartialBlock(first: [AnyPCView]) -> [AnyPCView] {
        first
    }

    static func buildPartialBlock(first: [any PCView]) -> [AnyPCView] {
        first.map(AnyPCView.init)
    }

    static func buildPartialBlock<F: PCView>(first: F) -> [AnyPCView] {
        [AnyPCView(first)]
    }

    static func buildPartialBlock<C: PCView>(accumulated: [AnyPCView], next: C) -> [AnyPCView] {
        accumulated + [AnyPCView(next)]
    }
}
