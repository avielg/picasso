//
//  ContentView.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            textExample()
            stackExample()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
