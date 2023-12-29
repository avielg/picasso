//
//  PCOptionalView.swift
//  Picasso
//
//  Created by Aviel Gross on 26.11.2023.
//

import SwiftUI

struct PCOptionalView: PCView {
    static let names = ["optional"]

    struct Optional: Codable {
        let content: AnyPCView
        let presentationFlag: String
    }

    private let optional: Optional
    private let modifiers: PCModifiersData?

    @ObservedObject private var flag: Flag

    var body: some View {
        if flag.value {
            optional.content
        }
    }

    enum Keys: CodingKey { case optional, modifiers }

    init(
        _ optional: Optional,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.optional = optional
        self.modifiers = modifiers().data()
        flag = PCContext.shared.flag(optional.presentationFlag)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        optional = try container.decode(Optional.self, forKey: .optional)
        flag = PCContext.shared.flag(optional.presentationFlag)
        modifiers = try container.decodeIfPresent(PCModifiersData.self, forKey: .modifiers)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(optional, forKey: .optional)
        if let modifiers {
            try container.encode(modifiers, forKey: .modifiers)
        }

    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(optional, modifiers: modifiers)
    }
}
