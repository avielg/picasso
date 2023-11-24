//
//  PCView.swift
//  Picasso
//
//  Created by Aviel Gross on 16.11.2023.
//

import AnyCodable
import SwiftUI

struct PCDataView: View {
    let data: Data

    var body: some View {
        Parser.view(from: data)
    }
}

struct AsyncPCView<Content: View>: View {
    let urlRequest: URLRequest
    let placeholder: Content

    @State var data: Data?
    @State var error: Error?

    var body: some View {
        content
            .animation(.spring, value: data)
    }

    @ViewBuilder
    var content: some View {
        if let data {
            PCDataView(data: data)
        } else if let error {
            errorView(error)
        } else {
            placeholder
                .task {
                    do {
                        let (data, _) = try await URLSession.shared.data(for: urlRequest)
                        self.data = data
                    } catch {
                        self.error = error
                    }
                }
        }
    }
}

extension AsyncPCView {
    func errorView(_ error: some Error) -> some View {
        VStack(alignment: .leading) {
            Text(error.title).bold()
            Text(error.subtitle)
            Text(error.description).font(.caption)
        }
        .foregroundStyle(Color.white)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemRed))
        }
        .padding()
    }
}
