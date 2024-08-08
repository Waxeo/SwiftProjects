//
//  ContentView.swift
//  ex00
//
//  Created by Matteo Gauvrit on 27/07/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Hello, world!")
            }
            HStack {
                Button("Click Me") {
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
