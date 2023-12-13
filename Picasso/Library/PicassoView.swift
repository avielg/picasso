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
        Parser.shared.view(from: data)
    }
}

struct PicassoView<Content: View>: View {
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
                .environment(\.requestConfig, urlRequest.requestConfig)
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

extension PicassoView {
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

struct URLRequestConfig {
    let cachePolicy: URLRequest.CachePolicy
    let timeoutInterval: TimeInterval
}

private struct ViewRequestConfigKey: EnvironmentKey {
    /// Default of ``URLRequest(url:cachePolicy:timeoutInterval:)``
    static let defaultValue: URLRequestConfig = .init(
        cachePolicy: .useProtocolCachePolicy,
        timeoutInterval: 60.0
    )
}

extension EnvironmentValues {
    var requestConfig: URLRequestConfig {
        get { self[ViewRequestConfigKey.self] }
        set { self[ViewRequestConfigKey.self] = newValue }
    }
}

extension URLRequest {
    var requestConfig: URLRequestConfig {
        .init(cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

    func with(_ config: URLRequestConfig) -> Self {
        guard let url else {
            assertionFailure()
            return self
        }
        guard cachePolicy != config.cachePolicy || timeoutInterval != config.timeoutInterval else {
            return self
        }
        return URLRequest(
            url: url,
            cachePolicy: config.cachePolicy,
            timeoutInterval: config.timeoutInterval
        )
    }
}
