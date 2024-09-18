//
//  functions.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
//

import SwiftUI
import OpenMeteoSdk

// Fonction pour rechercher des villes par leur nom (Affichage liste des villes)
func searchCities(_ inputText: String, completion: @escaping ([City]) -> Void) {
    
    guard !inputText.isEmpty else {
        completion([])  // Renvoie un tableau vide si l'entrée est vide
        return
    }

    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(inputText)&count=5&language=fr"
    guard let url = URL(string: urlString) else { return }

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("JSON Response: \(jsonString)")
                }
                let decodedResponse = try JSONDecoder().decode(CityResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse.results)  // Renvoie les résultats via le closure
                }
            } catch {
                print("Erreur lors du décodage JSON : \(error)")
                DispatchQueue.main.async {
                    completion([])  // En cas d'erreur, renvoie un tableau vide
                }
            }
        } else {
            DispatchQueue.main.async {
                completion([])  // Si pas de données, renvoie un tableau vide
            }
        }
    }
    task.resume()
}

//func getWeatherDescription(weather_code: Int8) -> WeatherInfo? {
//    
//    return (WeatherMap.data["\(weather_code)"] ?? nil)
//}

func fetchCityInfo(city: City) async -> CityInfo? {
    var cityInfo = CityInfo(city: city)
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,is_day,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min"
    
    if (city.timezone != nil) {
        urlString += "&timezone=\(String(describing: city.timezone))"
    }
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        return nil
    }
    do {
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            return nil
        }
        
        let decodedResponse = try JSONDecoder().decode(CityInfo.self, from: data)
        
        cityInfo.current = decodedResponse.current
        cityInfo.hourly = decodedResponse.hourly
        cityInfo.daily = decodedResponse.daily
        
        return cityInfo
        
    } catch {
        print("Failed to fetch data")
    }
    
    return nil
}

// Fonction pour obtenir l'interprétation d'un code
func wmoCode(_ code: Int8?) -> WMOInterpretation {
    if let code = code, let interpretation = WMO_CODES[code] {
        return interpretation
    }
    return WMOInterpretation(color: "#FFFFFF", description: "...", icon: "")
}

func convertToHourlyEntries(hourlyData: HourlyData) -> [HourlyEntry] {
    var entries: [HourlyEntry] = []
        
    for index in 0..<24 {
        let entry = HourlyEntry(
            hour: extractTime(from: hourlyData.time[index])!,
            temperature: hourlyData.temperature_2m[index]
        )
        entries.append(entry)
    }
    
    return entries
}

func extractTime(from dateTimeString: String) -> String? {
    // Créer un DateFormatter pour analyser la chaîne de date-heure
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
    
    // Convertir la chaîne en Date
    guard let date = dateFormatter.date(from: dateTimeString) else {
        return nil
    }
    
    // Créer un DateFormatter pour extraire l'heure
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "HH:mm"
    
    // Convertir la date en chaîne de caractères avec le format d'heure
    return timeFormatter.string(from: date)
}

func convertToWeeklyEntries(weeklyData: WeeklyData) -> [WeeklyEntry] {
    var entries: [WeeklyEntry] = []
        
    for index in 0..<7 {
        let entry = WeeklyEntry(
            day: weeklyData.time[index],
            temperature_max: weeklyData.temperature_2m_max[index],
            temperature_min: weeklyData.temperature_2m_min[index]
        )
        entries.append(entry)
    }
    
    return entries
}
