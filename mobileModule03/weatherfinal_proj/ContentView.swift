//
//  ContentView.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
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
    @State private var showingAlert = false
    @State var hasFetchedData: Bool = false

    var body: some View {
        ZStack {

            TabView {
                CurrentlyView(cityInfo: locationManager.cityInfo, hasFetchedData: hasFetchedData)
                    .tabItem {
                        Label("Currently", systemImage: "thermometer.sun")
                    }
                TodayView(cityInfo: locationManager.cityInfo, hasFetchedData: hasFetchedData)
                    .tabItem {
                        Label("Today", systemImage: "calendar.day.timeline.trailing")
                    }
                WeeklyView(cityInfo: locationManager.cityInfo, hasFetchedData: hasFetchedData)
                    .tabItem {
                        Label("Weekly", systemImage: "calendar.circle")
                    }
            }
            
            VStack {
                // Barre de recherche et bouton en haut
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            // Check the authorization status after a short delay
                            if let status = locationManager.retuserLocStatus(), status == .denied || status == .restricted {
                                showingAlert = true
                            }
                        }
                        if (locationManager.cityLocation != nil) {
                            print("Geolocation pressed and cityLocation exist !")
                            Task {
                                let cityInfoFetching = await fetchCityInfo(city: locationManager.cityLocation!)
                                locationManager.cityInfo = cityInfoFetching
                            }
                            hasFetchedData = true
                        } else {
                            print("Geolocation pressed but cityLocation not exist !")
                        }
                    }) {
                        Image(systemName: "location.viewfinder")
                            .font(.system(size: 30))
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Location Disabled"),
                            message: Text("Your location services are disabled or restricted. Please enable them in the settings."),
                            primaryButton: .default(Text("Settings")) {
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .padding(.top) // Espacement en haut pour le HStack

                Spacer() // Espacement pour pousser le contenu du haut vers le haut

                if !suggestions.isEmpty {
                    List(suggestions) { city in
                        let name = "\(city.name), \(city.admin1), \(city.country)"
                        Text(name)
                            .onTapGesture {
                                Task {
                                    let cityInfoFetching = await fetchCityInfo(city: city)
                                    locationManager.cityInfo = cityInfoFetching
                                }
                                hasFetchedData = true
                                inputText = ""
                                suggestions.removeAll()
                            }
                    }
                    .listStyle(PlainListStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Coins arrondis
                    .shadow(radius: 5)
                    .padding(.bottom) // Espacement en bas pour le List

                }
            }
            .padding() // Padding général pour la VStack
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, Color("lightblue")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
