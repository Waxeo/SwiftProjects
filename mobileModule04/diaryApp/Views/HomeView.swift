//
//  HomeView.swift
//  diaryApp
//
//  Created by Matteo Gauvrit on 25/09/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                
                TabView {
                    ProfilePageView()
                        .tabItem {
                            Image(systemName: "person.crop.circle.fill")
                            Text("Profile")
                        }
                    
                    CalendarView()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Calendar")
                            
                        }
                }
                
            }
        }
    }
}

#Preview {
    HomeView()
}
