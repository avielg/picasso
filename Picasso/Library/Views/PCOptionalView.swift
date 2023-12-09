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

    let optional: Optional

    @ObservedObject private var flag: Flag

    var body: some View {
        if flag.value {
            optional.content
        }
    }

    enum Keys: CodingKey { case optional }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        optional = try container.decode(Optional.self, forKey: .optional)
        flag = Context.shared.flag(optional.presentationFlag)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(optional, forKey: .optional)
    }
}
