//
//  TodayView.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
//

import SwiftUI
import Charts

//In your second tab “Today” you will have to display:
//
//• The location (city name, region and country).
//• The list of the weather for the day with the following data:
//    ◦ The hours.
//    ◦ The temperatures by hours.
//    ◦ The weather description (cloudy, sunny, rainy, etc.) by hours.
//    ◦ The wind speed (in km/h) by hours.


struct TodayView: View {
        
    var cityInfo: CityInfo?
    var hasFetchedData: Bool
    
//    Trois possibilitées:
//    - l'utilisateur n'a pas encore fetch des données, auquel cas pas de data mais un petit message pour demander a chercher une location
//    - il a cherché et tout s'est bien passé auquel cas on affiche les données
//    - il a bien cherché, MAIS le fetch a eu un soucis, message d'erreur - lié a connexion internet
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                if hasFetchedData == false {
                    Text("Please search for a city or enable geolocation.")
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                } else if (cityInfo?.city != nil && cityInfo?.current != nil) {
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .renderingMode(.original)
                            .font(.title)
                        
                        Text("\(cityInfo?.city?.name ?? "Unknow"), \(cityInfo?.city?.admin1 ?? ""), \(cityInfo?.city?.country ?? "")")
                            .font(.title2)
                    }
                    
                    // Graphique des températures
                    
                    let data = convertToHourlyEntries(hourlyData: (cityInfo?.hourly)!)
                    
                    Chart(data, id: \.hour) { entry in
                        LineMark(
                            x: .value("Hour", entry.hour),
                            y: .value("Temperature", entry.temperature)
                        )
                    }
                    .frame(height: 300)
                    .padding(.horizontal)
//                    .chartXAxis {
//                        AxisMarks(values: .stride(by: .hour)) { value in
//                            AxisGridLine()
//                            AxisTick()
//                            AxisValueLabel(format: .dateTime.hour())
//                        }
//                        
//                    }
                    
                                        
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<24, id: \.self) { index in
                                VStack {
                                    Text("\(cityInfo?.hourly?.time[index] ?? "Unknown")")
                                    
                                    if let temperature = cityInfo?.hourly?.temperature_2m[index] {
                                        Text("\(String(format: "%.1f", temperature))°C")
                                    }
                                    
                                    if let weatherCode = cityInfo?.hourly?.weather_code[index] {
                                        let interpretation = wmoCode(weatherCode)
                                        
                                        Image("\(interpretation.icon)")
                                            .resizable()  // Rendre l'image redimensionnable
                                            .scaledToFit()
                                            .background(Color.clear.opacity(0))
                                            .frame(width: 30, height: 30)
                                    }
                                    
                                    if let windSpeed = cityInfo?.hourly?.wind_speed_10m[index] {
                                        Text("\(String(format: "%.1f", windSpeed)) km/h")
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding()
                        
                    }
                    .frame(height: 150) // Définit une hauteur spécifique pour la liste
                    .padding(.bottom, 20)
                    
                } else {
                    Text("Failed to fetch data.\nPlease check your internet connection.")
                        .background(Color.red)
                        .cornerRadius(8)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
