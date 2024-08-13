//
//  CurrentlyView.swift
//  weatherApp_proj
//
//  Created by Matteo Gauvrit on 09/08/2024.
//

import SwiftUI

struct CurrentlyView: View {
        
    @Binding var inputText: String
    
    var body: some View {
        VStack {
            Text("Currently")
            Text("\(inputText)")
        }
    }
}
