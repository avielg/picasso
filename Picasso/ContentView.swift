//
//  ContentView.swift
//  Picasso
//
//  Created by Aviel Gross on 11.11.2023.
//

import SwiftUI

struct ContentView: View {

    let request = URL(string: "https://f001.backblazeb2.com/file/Picasso/Example.json")!
    let requestScrollView = URL(string: "https://f001.backblazeb2.com/file/Picasso/Example2.json")!
    let requestErrorDecode = URL(string: "https://f001.backblazeb2.com/file/Picasso/ExampleErrorDecode.json")!
    let requestErrorCorrupt = URL(string: "https://f001.backblazeb2.com/file/Picasso/ExampleErrorCorrupt.json")!

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
                Section("Local") {
                    NavigationLink {
                        ScrollView {
                            VStack {
                                imagesExample()
                                shapesExample()
                                textExample()
                                stackExample()
                                asyncExamples()
                            }
                            .padding()
                        }
                    } label: {
                        Text("Misc Examples")
                    }

                    NavigationLink {
                        Parser.shared.view(from: scrollView_example2)
                    } label: {
                        Text("Horizontal ScrollView")
                    }

                    NavigationLink {
                        Parser.shared.view(from: button_json1)
                    } label: {
                        Text("Button & Sheet")
                    }
                }

                Section("Remote") {
                    NavigationLink {
                        PicassoView(request)
                            .padding()
                    } label: {
                        label("Texts & Stacks", subtitle: "No Placeholder")
                    }

                    NavigationLink {
                        PicassoView(request, placeholder: Color.red)
                            .padding()
                    } label: {
                        label("Texts & Stacks", subtitle: "Red Placeholder")
                    }

                    NavigationLink {
                        PicassoView(request, placeholder: ProgressView())
                            .padding()
                    } label: {
                        label("Texts & Stacks", subtitle: "Progress View")
                    }

                    NavigationLink {
                        PicassoView(request)
                            .border(Color.blue)
                            .padding()
                    } label: {
                        label("Texts & Stacks", subtitle: "With border")
                    }
                }


                Section("Remote") {
                    NavigationLink {
                        PicassoView(requestScrollView)
                    } label: {
                        label("ScrollView", subtitle: "No Placeholder")
                    }
                }

                Section("Error") {
                    NavigationLink {
                        PicassoView(requestErrorDecode)
                    } label: {
                        label("Decode Issue", subtitle: "No Placeholder")
                    }

                    NavigationLink {
                        PicassoView(requestErrorCorrupt)
                    } label: {
                        label("Corrupted JSON", subtitle: "No Placeholder")
                    }
                }
            }
            .navigationTitle("Examples")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
