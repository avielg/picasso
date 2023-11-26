//
//  CodableEdgeInsets.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SwiftUI

extension EdgeInsets: Codable {
    enum Keys: CodingKey {
        case top, leading, trailing, bottom
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self = .init(
            top: try container.decodeIfPresent(CGFloat.self, forKey: .top) ?? 0,
            leading: try container.decodeIfPresent(CGFloat.self, forKey: .leading) ?? 0,
            bottom: try container.decodeIfPresent(CGFloat.self, forKey: .bottom) ?? 0,
            trailing: try container.decodeIfPresent(CGFloat.self, forKey: .trailing) ?? 0
        )
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        try container.encode(self.top, forKey: .top)
        try container.encode(self.leading, forKey: .leading)
        try container.encode(self.bottom, forKey: .bottom)
        try container.encode(self.trailing, forKey: .trailing)
    }
}
