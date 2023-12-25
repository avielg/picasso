//
//  PicassoApp.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI
import ZippyJSON

@main
struct PicassoApp: App {

    let setup: Void = {
        Parser.shared = Parser(encoder: JSONEncoder(), decoder: ZippyJSONDecoder())
        CustomFont.weights[.regular] = "MuseoModerno-Regular"
        CustomFont.weights[.bold] = "MuseoModerno-Bold"
        CustomFont.weights[.semibold] = "MuseoModerno-SemiBold"
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
