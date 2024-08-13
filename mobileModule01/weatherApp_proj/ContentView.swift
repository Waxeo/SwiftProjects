//
//  ContentView.swift
//  weatherApp_proj
//
//  Created by Matteo Gauvrit on 09/08/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct HomeView: View {
    
//    @StateObject private var locationManager = LocationManager()
    @State private var inputText: String = ""
//    @State private var errorMessage: String? = nil
    
    var body: some View {
        
        VStack {
            HStack {
                
                TextField("Search location...", text: $inputText)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .padding()
                
                Button(action: {
                    inputText = "Geolocation"
//                    if let location = locationManager.location {
//                        inputText = "Lat: \(location.coordinate.latitude)\nLong: \(location.coordinate.longitude)"
//                        errorMessage = nil  // Réinitialiser le message d'erreur si la localisation est disponible
//                    } else if locationManager.authorizationStatus == .denied {
//                        errorMessage = "Accès à la localisation refusé. Veuillez activer la localisation dans les réglages."
//                    } else {
//                        errorMessage = "Localisation non disponible."
//                    }
                }) {
                    Image(systemName: "location.viewfinder")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)
                }
                .padding()
            }
            
            Spacer()
            
            TabView {
                CurrentlyView(inputText : $inputText)
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
    
//    class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//            
//        private var locationManager = CLLocationManager()
//        @Published var location: CLLocation? = nil
//        // Ajouter une variable pour le statut de l'autorisation
//        @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
//        
//        override init() {
//            super.init()
//            self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            self.locationManager.requestWhenInUseAuthorization()
//            self.locationManager.startUpdatingLocation()
//            // Initialiser le statut de l'autorisation
//            self.authorizationStatus = locationManager.authorizationStatus
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//            self.authorizationStatus = status  // Mettre à jour le statut de l'autorisation lorsque cela change
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            guard let latestLocation = locations.first else { return }
//            self.location = latestLocation
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Erreur lors de l'obtention de la localisation : \(error.localizedDescription)")
//        }
//    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
