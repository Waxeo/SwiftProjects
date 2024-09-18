//
//  WeeklyView.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
//

import SwiftUI
import Charts

//In your third tab “Weekly” you will have to display:
//• The location (city name, region and country).
//• The list of the weather for each day of the week with the following data:
//    ◦ The date.
//    ◦ The min and max temperatures of the day
//    ◦ The weather description (cloudy, sunny, rainy, etc.).

struct WeeklyView: View {
    
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
                    
                    let data = convertToWeeklyEntries(weeklyData: (cityInfo?.daily)!)
                    
                    Chart(data, id: \.day) { entry in
                        Plot {
                            LineMark(
                                x: .value("Hour", entry.day),
                                y: .value("Temperature", entry.temperature_max)
                            )
                            .foregroundStyle(by: .value("Temperature", "max"))
                            
                            LineMark(
                                x: .value("Hour", entry.day),
                                y: .value("Temperature", entry.temperature_min)
                            )
                            .foregroundStyle(by: .value("Temperature", "min"))
                        }
                        .interpolationMethod(.catmullRom)
                    }
                    .chartForegroundStyleScale(["max": .red, "min":.blue])
                    .frame(height: 300)
                    .padding(.horizontal)
                                        
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(0..<7, id: \.self) { index in
                                VStack {
                                    
                                    Text("\(cityInfo?.daily?.time[index] ?? "Unknown")")
                                    
                                    if let weatherCode = cityInfo?.daily?.weather_code[index] {
                                        let interpretation = wmoCode(weatherCode)
                                        
                                        Image("\(interpretation.icon)")
                                            .resizable()  // Rendre l'image redimensionnable
                                            .scaledToFit()
                                            .background(Color.clear.opacity(0))
                                            .frame(width: 30, height: 30)
                                    }
                                    
                                    if let max = cityInfo?.daily?.temperature_2m_max[index] {
                                        Text("Max:\(String(format: "%.1f", max))°C")
                                            .foregroundColor(.red)
                                    }
                                    
                                    if let min = cityInfo?.daily?.temperature_2m_min[index] {
                                        Text("Min:\(String(format: "%.1f", min))°C")
                                            .foregroundColor(.blue)
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
//                    .padding(.bottom, 20)
                    
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

