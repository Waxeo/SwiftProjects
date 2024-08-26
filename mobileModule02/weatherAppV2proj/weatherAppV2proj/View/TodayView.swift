//
//  TodayView.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 13/08/2024.
//

import SwiftUI

struct TodayView: View {
        
    @Binding var inputText: String
    
    var body: some View {
        VStack {
            Text("Today")
            Text("\(inputText)")
        }
    }
}
