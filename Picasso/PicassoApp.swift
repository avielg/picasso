//
//  PicassoApp.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI

@main
struct PicassoApp: App {

    let customFont: Void = {
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
