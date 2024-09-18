//
//  CurrentlyView.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
//

import SwiftUI

//In your first tab “Current” you will have to display:
//
//• The location (city name, region and country).
//• The current temperature (in Celsius).
//• The current weather description (cloudy, sunny, rainy, etc.).
//• the current wind speed (in km/h).


struct CurrentlyView: View {

    var cityInfo: CityInfo?
    var hasFetchedData: Bool

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                if !hasFetchedData {
                    Text("Please search for a city or enable geolocation.")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .background(Color.clear.opacity(0))

                } else if let cityInfo = cityInfo, let currentWeather = cityInfo.current {
                    
                    GeometryReader { geometry in
                        ScrollView {
                            Spacer()
                            VStack(spacing: 20) {
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .renderingMode(.original)
                                            .background(Color.clear.opacity(0))
                                            .font(.title)
                                        
                                        VStack(alignment: .leading) {
                                            Text("\(cityInfo.city?.name ?? "Unknown"),")
                                                .font(.custom("Copperplate", size: 28))
                                                .background(Color.clear.opacity(0))
                                            Text("\(cityInfo.city?.admin1 ?? ""), \(cityInfo.city?.country ?? "")")
                                                .font(.custom("Copperplate", size: 28))
                                                .background(Color.clear.opacity(0))
                                        }
                                    }
                                    
                                    Divider()
                                        .frame(height: 50)
                                        .padding(.horizontal)
                                        .foregroundColor(.black.opacity(1))
                                    
                                    if let weatherCode = cityInfo.current?.weather_code {
                                        let interpretation = wmoCode(weatherCode)
                                        Image("\(interpretation.icon)")
                                            .resizable()  // Rendre l'image redimensionnable
                                            .scaledToFit()
                                            .background(Color.clear.opacity(0))
                                            .frame(width: 100, height: 100)
                                        
                                        Text("\(interpretation.description)")
                                            .background(Color.clear.opacity(0))
                                            .font(.title)
                                        
                                        Divider()
                                            .frame(height: 50)
                                            .padding(.horizontal)
                                            .foregroundColor(.black.opacity(1))
                                        
                                        
                                        HStack {
                                            Image(systemName: "wind")
                                                .renderingMode(.original)
                                                .background(Color.clear.opacity(0))
                                                .font(.title)
                                            
                                            if (cityInfo.current?.wind_speed_10m != nil) {
                                                Text("\(String(format: "%.1f", cityInfo.current!.wind_speed_10m)) km/h")
                                                    .background(Color.clear.opacity(0))
                                            }
                                            
                                            Divider()
                                                .frame(height: 50)
                                                .padding(.horizontal)
                                                .foregroundColor(.black.opacity(1))
                                            
                                            if (cityInfo.current?.temperature_2m != nil) {
                                                if (cityInfo.current!.temperature_2m >= 20) {
                                                    Text("\(String(format: "%.1f", cityInfo.current!.temperature_2m))°C")
                                                        .background(Color.clear.opacity(0))
                                                        .foregroundColor(.red)
                                                        .font(.title)
                                                }
                                                else {
                                                    Text("\(String(format: "%.1f", cityInfo.current!.temperature_2m))°C")
                                                        .background(Color.clear.opacity(0))
                                                        .foregroundColor(.blue)
                                                        .font(.title)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(minHeight: geometry.size.height)
                            .padding(.horizontal)
                        }
                        .backgroundStyle(Color.gray.opacity(0.05))
                    }
                } else {
                    Text("Failed to fetch data.\nPlease check your internet connection.")
                        .background(Color.red)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
            }
            .background(Color.clear.opacity(0))
        }
    }
}
