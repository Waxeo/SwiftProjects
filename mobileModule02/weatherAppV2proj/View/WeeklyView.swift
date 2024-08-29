//
//  WeeklyView.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 13/08/2024.
//

import SwiftUI

//In your third tab “Weekly” you will have to display:
//• The location (city name, region and country).
//• The list of the weather for each day of the week with the following data:
//    ◦ The date.
//    ◦ The min and max temperatures of the day
//    ◦ The weather description (cloudy, sunny, rainy, etc.).

struct WeeklyView: View {
    
    var cityInfo: CityInfo?

    var body: some View {
        VStack {
            if (cityInfo?.city != nil && cityInfo?.current != nil) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .renderingMode(.original)
                        .font(.title)
                    
                    Text("\(cityInfo?.city?.name ?? "Unknow"), \(cityInfo?.city?.admin1 ?? ""), \(cityInfo?.city?.country ?? "")")
                        .font(.title2)
                }
                
                Spacer()
                
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(0..<7, id: \.self) { index in
                            VStack {
                                
                                Text("\(cityInfo?.daily?.time[index] ?? "Unknown")")
                                
                                if let temperature = cityInfo?.daily?.temperature_2m_max[index] {
                                    Text("Max:\(String(format: "%.1f", temperature))°C")
                                }
                                
                                if let windSpeed = cityInfo?.daily?.temperature_2m_min[index] {
                                    Text("Min:\(String(format: "%.1f", windSpeed))°C")
                                }
                                
                                if let weatherCode = cityInfo?.daily?.weather_code[index] {
                                    Text("\(getWeatherDescription(weather_code: weatherCode)?.dayDescription ?? "")")
                                }
                
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding()

                }
                
                Spacer()
                
            }
            else {
                Text("Invalid data")
            }
        }
    }
}
