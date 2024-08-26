//
//  struct.swift
//  weatherAppV2proj
//
//  Created by Matteo Gauvrit on 14/08/2024.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Foundation

// Structure pour récuperer la réponse JSON de l'api Geocoding
struct City: Codable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let featureCode: String
    let countryCode: String
    let admin1ID: Int
    let admin2ID: Int?
    let admin3ID: Int?
    let admin4ID: Int?
    let timezone: String
    let population: Int?
    let postcodes: [String]?
    let countryID: Int
    let country: String
    let admin1: String
    let admin2: String?
    let admin3: String?
    let admin4: String?
    
    // Enum pour mapper les noms des clés JSON aux propriétés Swift
    enum CodingKeys: String, CodingKey {
        case id, name, latitude, longitude, elevation
        case featureCode = "feature_code"
        case countryCode = "country_code"
        case admin1ID = "admin1_id"
        case admin2ID = "admin2_id"
        case admin3ID = "admin3_id"
        case admin4ID = "admin4_id"
        case timezone, population, postcodes
        case countryID = "country_id"
        case country, admin1, admin2, admin3, admin4
    }
}

// Modèle pour la réponse complète
struct CityResponse: Codable {
    let results: [City]
}

struct CityInfo: Codable {
    // CITY
    var city: City?
    
    // CURRENT TAB
    var current: CurrentData?
    // TODAY TAB
    var hourly: HourlyData?
    // WEEKLY TAB
    var daily: WeeklyData?
}

struct CurrentData: Codable {
    var time: String
    var temperature_2m: Double
    var is_day: Int8
    var weather_code: Int8
    var wind_speed_10m: Double
}

struct HourlyData: Codable {
    var time: Array<String>
    var temperature_2m: Array<Double>
    var weather_code: Array<Int8>
    var wind_speed_10m: Array<Double>
}

struct WeeklyData: Codable {
    var time: Array<String>
    var weather_code: Array<Int8>
    var temperature_2m_max: Array<Double>
    var temperature_2m_min: Array<Double>
}


struct WeatherInfo {
    let dayDescription: String
    let nightDescription: String
    let dayImageURL: String
    let nightImageURL: String
}

struct WeatherMap {
    static let data: [String: WeatherInfo] = [
        "0": WeatherInfo(dayDescription: "Sunny", nightDescription: "Clear", dayImageURL: "http://openweathermap.org/img/wn/01d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/01n@2x.png"),
        "1": WeatherInfo(dayDescription: "Mainly Sunny", nightDescription: "Mainly Clear", dayImageURL: "http://openweathermap.org/img/wn/01d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/01n@2x.png"),
        "2": WeatherInfo(dayDescription: "Partly Cloudy", nightDescription: "Partly Cloudy", dayImageURL: "http://openweathermap.org/img/wn/02d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/02n@2x.png"),
        "3": WeatherInfo(dayDescription: "Cloudy", nightDescription: "Cloudy", dayImageURL: "http://openweathermap.org/img/wn/03d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/03n@2x.png"),
        "45": WeatherInfo(dayDescription: "Foggy", nightDescription: "Foggy", dayImageURL: "http://openweathermap.org/img/wn/50d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/50n@2x.png"),
        "48": WeatherInfo(dayDescription: "Rime Fog", nightDescription: "Rime Fog", dayImageURL: "http://openweathermap.org/img/wn/50d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/50n@2x.png"),
        "51": WeatherInfo(dayDescription: "Light Drizzle", nightDescription: "Light Drizzle", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "53": WeatherInfo(dayDescription: "Drizzle", nightDescription: "Drizzle", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "55": WeatherInfo(dayDescription: "Heavy Drizzle", nightDescription: "Heavy Drizzle", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "56": WeatherInfo(dayDescription: "Light Freezing Drizzle", nightDescription: "Light Freezing Drizzle", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "57": WeatherInfo(dayDescription: "Freezing Drizzle", nightDescription: "Freezing Drizzle", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "61": WeatherInfo(dayDescription: "Light Rain", nightDescription: "Light Rain", dayImageURL: "http://openweathermap.org/img/wn/10d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/10n@2x.png"),
        "63": WeatherInfo(dayDescription: "Rain", nightDescription: "Rain", dayImageURL: "http://openweathermap.org/img/wn/10d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/10n@2x.png"),
        "65": WeatherInfo(dayDescription: "Heavy Rain", nightDescription: "Heavy Rain", dayImageURL: "http://openweathermap.org/img/wn/10d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/10n@2x.png"),
        "66": WeatherInfo(dayDescription: "Light Freezing Rain", nightDescription: "Light Freezing Rain", dayImageURL: "http://openweathermap.org/img/wn/10d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/10n@2x.png"),
        "67": WeatherInfo(dayDescription: "Freezing Rain", nightDescription: "Freezing Rain", dayImageURL: "http://openweathermap.org/img/wn/10d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/10n@2x.png"),
        "71": WeatherInfo(dayDescription: "Light Snow", nightDescription: "Light Snow", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "73": WeatherInfo(dayDescription: "Snow", nightDescription: "Snow", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "75": WeatherInfo(dayDescription: "Heavy Snow", nightDescription: "Heavy Snow", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "77": WeatherInfo(dayDescription: "Snow Grains", nightDescription: "Snow Grains", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "80": WeatherInfo(dayDescription: "Light Showers", nightDescription: "Light Showers", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "81": WeatherInfo(dayDescription: "Showers", nightDescription: "Showers", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "82": WeatherInfo(dayDescription: "Heavy Showers", nightDescription: "Heavy Showers", dayImageURL: "http://openweathermap.org/img/wn/09d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/09n@2x.png"),
        "85": WeatherInfo(dayDescription: "Light Snow Showers", nightDescription: "Light Snow Showers", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "86": WeatherInfo(dayDescription: "Snow Showers", nightDescription: "Snow Showers", dayImageURL: "http://openweathermap.org/img/wn/13d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/13n@2x.png"),
        "95": WeatherInfo(dayDescription: "Thunderstorm", nightDescription: "Thunderstorm", dayImageURL: "http://openweathermap.org/img/wn/11d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/11n@2x.png"),
        "96": WeatherInfo(dayDescription: "Light Thunderstorms With Hail", nightDescription: "Light Thunderstorms With Hail", dayImageURL: "http://openweathermap.org/img/wn/11d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/11n@2x.png"),
        "99": WeatherInfo(dayDescription: "Thunderstorm With Hail", nightDescription: "Thunderstorm With Hail", dayImageURL: "http://openweathermap.org/img/wn/11d@2x.png", nightImageURL: "http://openweathermap.org/img/wn/11n@2x.png")
    ]
}
