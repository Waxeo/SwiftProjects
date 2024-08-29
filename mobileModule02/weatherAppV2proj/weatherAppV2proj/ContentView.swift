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
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var suggestions: [City] = []
    @State private var inputText: String = ""
    @State private var latitude: Double = 0
    private var retErr: Int = 0


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
                    locationManager.requestLocation()
                    if (locationManager.cityLocation != nil) {
                        print("Geolocation pressed and cityLocation exist !")
                        Task {
                            let cityInfoFetching = await fetchCityInfo(city: locationManager.cityLocation!)
                            locationManager.cityInfo = cityInfoFetching
                        }
                    } else {
                        
                        print("Geolocation pressed but cityLocation not exist !")
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
                        let name = "\(city.name), \(city.admin1), \(city.country)"
                        Text(name)
                            .onTapGesture {
                                Task {
                                    let cityInfoFetching = await fetchCityInfo(city: city)
                                    locationManager.cityInfo = cityInfoFetching
                                }
                                inputText = ""
                                suggestions.removeAll()
                            }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            
            Spacer()
            
            TabView {
                CurrentlyView(cityInfo: locationManager.cityInfo)
                    .tabItem {
                        Image(systemName: "thermometer.sun")
                        Text("Currently")
                    }
                TodayView(cityInfo: locationManager.cityInfo)
                    .tabItem {
                        Image(systemName: "calendar.day.timeline.trailing")
                        Text("Today")
                    }
                WeeklyView(cityInfo: locationManager.cityInfo)
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


