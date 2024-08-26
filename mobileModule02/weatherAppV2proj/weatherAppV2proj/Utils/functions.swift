//
//  functions.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 17/08/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI
import OpenMeteoSdk
import Foundation

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
                    print("JSON Response: \(jsonString)")
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

// Fonction pour rechercher des villes par leur coordonées (Affichage liste des villes)
func revSearchCities(latitude: Double, longitude: Double, completion: @escaping (City?) -> Void) {
    let urlString = "https://api.open-meteo.com/v1/reverse-geocoding?latitude=\(latitude)&longitude=\(longitude)"
    
    if let url = URL(string: urlString) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la requête: \(error)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let city = try JSONDecoder().decode([City].self, from: data)
                    
                    if let locationDetails = city.first {
                        print("Détails du lieu : \(locationDetails)")
                        completion(locationDetails)
                    } else {
                        print("Aucun détail trouvé pour ces coordonnées.")
                        completion(nil)
                    }
                } catch {
                    print("Erreur lors du décodage des données JSON: \(error)")
                    completion(nil)
                }
            }
        }
        task.resume()
    }
}

func getWeatherDescription(weather_code: Int8) -> WeatherInfo? {
    
    return (WeatherMap.data["\(weather_code)"] ?? nil)
}

func fetchCityInfo(city: City) async -> CityInfo? {
    var cityInfo = CityInfo(city: city)
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,is_day,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min"
    if (!(city.timezone.isEmpty)) {
        urlString += "&timezone=\(city.timezone)"
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
