//
//  ContentView.swift
//  ex01
//
//  Created by Matteo Gauvrit on 27/07/2024.
//

import SwiftUI

struct HomeView: View {
    var txt = ["A simple text", "Hello, world!"]
    @State var index = 0
    var body: some View {
        VStack {
            
            HStack {
                Text(txt[index])
            }
            HStack {
                Button("Click Me") {
                    if index == 0 {
                        index = 1
                    } else {
                        index = 0
                    }
                    print("Button pressed")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.secondary)
            }
            
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
