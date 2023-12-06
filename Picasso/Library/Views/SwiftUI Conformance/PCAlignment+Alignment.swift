//
//  PCAlignment+Alignment.swift
//  Picasso
//
//  Created by Aviel Gross on 05.12.2023.
//

import SwiftUI

extension PCAlignment {
    var toAlignment: Alignment {
        switch self {
        case .center: .center
        case .leading: .leading
        case .trailing: .trailing
        case .top: .top
        case .bottom: .bottom
        case .topLeading: .topLeading
        case .topTrailing: .topTrailing
        case .bottomLeading: .bottomLeading
        case .bottomTrailing: .bottomTrailing
        case .listRowSeparatorLeading: .init(horizontal: .listRowSeparatorLeading, vertical: .center)
        case .listRowSeparatorTrailing: .init(horizontal: .listRowSeparatorTrailing, vertical: .center)
        case .firstTextBaseline: .init(horizontal: .center, vertical: .firstTextBaseline)
        case .lastTextBaseline: .init(horizontal: .center, vertical: .lastTextBaseline)
        }
    }

    static func from(_ alignment: Alignment) -> Self {
        switch alignment {
        case .center: .center
        case .leading: .leading
        case .trailing: .trailing
        case .top: .top
        case .bottom: .bottom
        case .topLeading: .topLeading
        case .topTrailing: .topTrailing
        case .bottomLeading: .bottomLeading
        case .bottomTrailing: .bottomTrailing
        case alignment where alignment.horizontal == .listRowSeparatorLeading: .listRowSeparatorLeading
        case alignment where alignment.horizontal == .listRowSeparatorTrailing: .listRowSeparatorTrailing
        case alignment where alignment.vertical == .firstTextBaseline: .firstTextBaseline
        case alignment where alignment.vertical == .lastTextBaseline: .lastTextBaseline
        default: fatalError()
        }
    }
}
