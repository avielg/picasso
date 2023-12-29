//
//  PCButton.swift
//  Picasso
//
//  Created by Aviel Gross on 25.11.2023.
//

import SafariServices
import SwiftUI

struct PCButton: PCView {
    static let names = ["button"]

    private let button: String

    enum Action {
        enum Navigation {
            case dismiss

            init?(from rawValue: String) {
                if rawValue == "\(Self.dismiss)" { self = .dismiss }
                else { return nil }
            }
        }

        case empty
        case toggleFlag(String)
        case openURL(URL)
        case presentURL(URL)
        case navigate(Navigation)
    }

    private let action: Action

    private let modifiers: PCModifiersData?

    @Environment(\.dismiss) private var dismiss

    @MainActor
    func performAction() {
        switch action {
        case .empty:
            break
        case .toggleFlag(let value):
            PCContext.shared.flag(value).value.toggle()
        case .openURL(let url):
            UIApplication.shared.open(url)
        case .presentURL(let url):
            UIApplication.shared.firstKeyWindow?.rootViewController?
                .present(SFSafariViewController(url: url), animated: true)
        case .navigate(let navigation):
            switch navigation {
            case .dismiss: dismiss()
            }
        }
    }

    var body: some View {
        Button(button, action: performAction)
            .modifier(Parser.shared.modifiers(from: modifiers))
    }

    enum Keys: CodingKey {
        case button
        case modifiers
        case openURL
        case presentURL
        case toggleFlag
        case navigate
    }

    init(
        _ title: String,
        action: Action,
        @ModifierBuilder modifiers: () -> some PCModifier = { PCEmptyModifier() }
    ) {
        self.button = title
        self.action = action
        self.modifiers = modifiers().data()
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
        } else if let navigationValue = try container.decodeIfPresent(String.self, forKey: .navigate) {
            self.action = Action.Navigation(from: navigationValue).map(Action.navigate) ?? .empty
        } else {
            self.action = .empty
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        try container.encode(button, forKey: .button)
        if let modifiers {
            try container.encode(modifiers, forKey: .modifiers)
        }

        switch action {
        case .empty:
            break
        case .toggleFlag(let flag):
            try container.encode(flag, forKey: .toggleFlag)
        case .openURL(let url):
            try container.encode(url, forKey: .openURL)
        case .presentURL(let url):
            try container.encode(url, forKey: .presentURL)
        case .navigate(let navigation):
            switch navigation {
            case .dismiss:
                try container.encode("\(navigation)", forKey: .navigate)
            }
        }
    }

    func modifiers(
        @ModifierBuilder modifiers: () -> some PCModifier
    ) -> Self {
        Self(button, action: action, modifiers: modifiers)
    }
}

extension UIApplication {
    var firstKeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .keyWindow
    }
}
