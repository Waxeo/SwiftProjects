//
//  ContentView.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 13/08/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI
import OpenMeteoSdk
import Foundation

struct HomeView: View {
    
    @StateObject private var locationManager = LocationManager()
    @State private var suggestions: [City] = []
    @State private var inputText: String = ""
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0

    var body: some View {
        
        VStack {
            HStack {
                
                TextField("Search location...", text: $inputText)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()
                   .onChange(of: inputText) {
                           searchCities(inputText) { cities in
                               self.suggestions = cities
                           }
                    }
                
                Button(action: {
                    if let location = locationManager.location {
                        inputText = "My position"
                        latitude = location.coordinate.latitude
                        longitude = location.coordinate.longitude
                    } else if locationManager.authorizationStatus == .denied {
                        print("Accès à la localisation refusé. Veuillez activer la localisation dans les réglages.")
                    } else {
                        print("Localisation non disponible.")
                    }
                }) {
                    Image(systemName: "location.viewfinder")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                .padding()
            }
            HStack {
                if !suggestions.isEmpty {
                    List(suggestions) { city in
                        Text(city.name + ", " + city.admin1 + ", " + city.country)
                            .onTapGesture {
                                inputText = city.name + ", " + city.admin1 + ", " + city.country
                                latitude = city.latitude
                                longitude = city.longitude
                                suggestions.removeAll()
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            Spacer()
            
            TabView {
                CurrentlyView(location: inputText, latitude: latitude, longitude: longitude)
                    .tabItem {
                        Image(systemName: "thermometer.sun")
                        Text("Currently")
                    }
                TodayView(inputText : $inputText)
                    .tabItem {
                        Image(systemName: "calendar.day.timeline.trailing")
                        Text("Today")
                    }
                WeeklyView(inputText : $inputText)
                    .tabItem {
                        Image(systemName: "calendar.circle")
                        Text("Weekly")
                    }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

