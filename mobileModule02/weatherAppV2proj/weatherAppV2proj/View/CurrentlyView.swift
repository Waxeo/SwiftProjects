//
//  CurrentlyView.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 13/08/2024.
//

import SwiftUI

struct CurrentlyView: View {
    
    let location: String
    let latitude: Double
    let longitude: Double
    @State private var selectedCity: CityInfo? = nil
    @State private var showError: Bool = false
    
    //    verifier avant toutes choses avec longitude latitude que la location existe bien, sinon ne rien afficher ? message d'erreur a voir
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .renderingMode(.original)
                Text(location)
            }
            
            Spacer()
            
            HStack {
                //                print(latitude)
                //                print(longitude)
            }
        }
        .onAppear {
            // Rechercher la ville dès que la vue apparaît
            revSearchCities(latitude: latitude, longitude: longitude) { city in
                if let city = city {
                    self.selectedCity?.city = city
//                    selectedCity?.current = fetchCityInfo(city: city)
                } else {
                    self.showError = true
                }
            }
        }
        //                Text(temperature) |
        //                Text(weather)     | --> Api open météo
        //                Text(wind)        |
    }
        
}



//In your first tab “Current” you will have to display:
//
//• The location (city name, region and country).
//• The current temperature (in Celsius).
//• The current weather description (cloudy, sunny, rainy, etc.). 
//• the current wind speed (in km/h).
