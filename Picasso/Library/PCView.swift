//
//  PCView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import AnyCodable
import SwiftUI

struct PCView: View {
    let json: [String: AnyCodable]
    
    var body: some View {
        Parser.view(from: json)
    }
}

struct AsyncPCView<Content: View>: View {
    let urlRequest: URLRequest
    let placeholder: Content

    @State var json: [String: AnyCodable]?

    var body: some View {
        if let json {
            PCView(json: json)
        } else {
            placeholder
                .task {
                    do {
                        let (data, _) = try await URLSession.shared.data(for: urlRequest)
                        json = try JSONDecoder().decode([String: AnyCodable].self, from: data)
                    } catch {
                        assertionFailure()
                    }
                }
        }
    }
}
