//
//  CurrentlyView.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 13/08/2024.
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

                HStack {
                    if (cityInfo?.current?.temperature_2m != nil) {
                        Text("\(String(format: "%.1f", cityInfo!.current!.temperature_2m))°C")
                    }  
                }
                HStack {
                    if (cityInfo?.current?.weather_code != nil) {
                        Text("\(getWeatherDescription(weather_code: cityInfo!.current!.weather_code)?.dayDescription ?? "")")
                    }
                }
                HStack {
                    if (cityInfo?.current?.wind_speed_10m != nil) {
                        Text("\(String(format: "%.1f", cityInfo!.current!.wind_speed_10m)) km/h")
                    }
                }
                
                Spacer()
            }
            else {
                Text("Invalid data")
            }
        }
    }
}
