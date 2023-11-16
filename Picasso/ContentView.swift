//
//  ContentView.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI

struct ContentView: View {

    let request: URLRequest = URLRequest(url: URL(string: "https://f001.backblazeb2.com/file/Picasso/Example.json")!)

    func label(_ title: String, subtitle: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            Text(subtitle)
                .font(.footnote).foregroundStyle(Color.secondary)
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                NavigationLink {
                    VStack {
                        textExample()
                        stackExample()
                    }
                    .padding()
                } label: {
                    Text("Local")
                }

                NavigationLink {
                    AsyncPCView(urlRequest: request, placeholder: Color.clear)
                        .padding()
                } label: {
                    label("Remote", subtitle: "No Placeholder")
                }

                NavigationLink {
                    AsyncPCView(urlRequest: request, placeholder: Color.red)
                        .padding()
                } label: {
                    label("Remote", subtitle: "Red Placeholder")
                }

                NavigationLink {
                    AsyncPCView(urlRequest: request, placeholder: ProgressView())
                        .padding()
                } label: {
                    label("Remote", subtitle: "Progress View")
                }

                NavigationLink {
                    AsyncPCView(urlRequest: request, placeholder: Color.clear)
                        .border(Color.blue)
                        .padding()
                } label: {
                    label("Remote", subtitle: "With border")
                }
            }
            .navigationTitle("Picasso Example")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
