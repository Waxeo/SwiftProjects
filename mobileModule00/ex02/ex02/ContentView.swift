//
//  ContentView.swift
//  ex02
//
//  Created by Matteo Gauvrit on 27/07/2024.
//

import SwiftUI

struct HomeView: View {
    let buttonsP = [
        ["7", "8", "9", "C", "AC"],
        ["4", "5", "6", "+", "-"],
        ["1", "2", "3", "*", "/"],
        ["0", ".", "00", "=", ""]
    ]
    
    let buttonsL = [
        ["9", "8", "7", "6", "5"],
        [".", "00", "C", "AC", ""],
        ["4", "3", "2", "1", "0"],
        ["+", "-", "*", "/", "="]
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                TopBar()
                
                if geometry.size.width > geometry.size.height {
                    // Landscape
                    ButtonGrid(buttons: buttonsL, columns: 10, minButtonHeight: 15)
                } else {
                    // Portrait
                    ButtonGrid(buttons: buttonsP, columns: 5, minButtonHeight: 80)
                }
                
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct ButtonGrid: View {
    let buttons: [[String]]
    let columns: Int
    let minButtonHeight: CGFloat
    @State var expression: String = "expression"
    @State var result: String = "result"
    @State var inter: String = ""
    
    var body: some View {
        
        HStack {
            // Expression zone
            Text(expression)
                .font(.system(size: 75))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(Color.black)
        }
        
        HStack {
            // Results zone
            Text(result)
                .font(.system(size: 75))
                .foregroundColor(Color.white)
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(Color(hue: 1.0, saturation: 0.09, brightness: 0.35))
        }
        
        let gridItems = Array(repeating: GridItem(.flexible(), spacing: 0), count: columns)
        
        LazyVGrid(columns: gridItems, spacing: 0) {
            ForEach(buttons.flatMap { $0 }, id: \.self) { buttonTitle in
                Button(action: {
                    print("\(buttonTitle) pressed")
                }) {
                    Text(buttonTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(hue: 0.073, saturation: 0.91, brightness: 0.941))
                        .foregroundColor(.white)
                        .font(.title)
                        .overlay(
                            Rectangle()
                                .stroke(Color.white, lineWidth: 1)
                        )
                }
                .frame(minHeight: minButtonHeight)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
}

struct TopBar: View {
    var body: some View {
        VStack {
            Text("Calculator")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
        }
        .padding(.top, 50)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(hue: 1.0, saturation: 0.09, brightness: 0.35))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
