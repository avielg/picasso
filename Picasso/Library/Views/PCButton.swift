//
//  PCButton.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SafariServices
import SwiftUI

struct PCButton: PCView {
    static var name: String { "button" }

    private let button: String

    enum Action: Codable {
        case empty
        case toggleFlag(String)
        case openURL(URL)
        case presentURL(URL)
    }

    private let action: Action

    private let modifiers: PCModifiersData?

    @MainActor
    func performAction() {
        switch action {
        case .empty:
            break
        case .toggleFlag(let value):
            Context.shared.flag(value).value.toggle()
        case .openURL(let url):
            UIApplication.shared.open(url)
        case .presentURL(let url):
            UIApplication.shared.firstKeyWindow?.rootViewController?
                .present(SFSafariViewController(url: url), animated: true)
        }
    }

    var body: some View {
        Button(button, action: performAction)
            .modifier(Parser.modifiers(from: modifiers))
    }

    enum Keys: CodingKey {
        case button
        case modifiers
        case openURL
        case presentURL
        case toggleFlag
    }

    init(title: String, action: Action, modifiers: PCModifiersData? = nil) {
        self.button = title
        self.action = action
        self.modifiers = modifiers
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.button = try container.decode(String.self, forKey: .button)
        self.modifiers = try container.decodeIfPresent(PCModifiersData.self, forKey: .modifiers)

        if let url = try container.decodeIfPresent(URL.self, forKey: .openURL) {
            self.action = .openURL(url)
        } else if let url = try container.decodeIfPresent(URL.self, forKey: .presentURL) {
            self.action = .presentURL(url)
        } else if let flag = try container.decodeIfPresent(String.self, forKey: .toggleFlag) {
            self.action = .toggleFlag(flag)
        } else {
            self.action = .empty
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(button, forKey: .button)
        try container.encode(modifiers, forKey: .modifiers)

        switch action {
        case .empty:
            break
        case .toggleFlag(let flag):
            try container.encode(flag, forKey: .toggleFlag)
        case .openURL(let url):
            try container.encode(url, forKey: .openURL)
        case .presentURL(let url):
            try container.encode(url, forKey: .presentURL)
        }
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
