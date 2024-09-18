//
//  struct.swift
//  weatherfinal_proj
//
//  Created by Matteo Gauvrit on 29/08/2024.
//

import Foundation
import UIKit
import SwiftUI

// Structure pour récuperer la réponse JSON de l"api Geocoding
struct City: Codable, Identifiable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var elevation: Double?
    var featureCode: String
    var countryCode: String
    var admin1ID: Int
    var admin2ID: Int?
    var admin3ID: Int?
    var admin4ID: Int?
    var timezone: String
    var population: Int?
    var postcodes: [String]?
    var countryID: Int
    var country: String
    var admin1: String
    var admin2: String?
    var admin3: String?
    var admin4: String?
    
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
    
    init(
        id: Int = 0,
        name: String = "Unknown",
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        elevation: Double? = nil,
        featureCode: String = "",
        countryCode: String = "",
        admin1ID: Int = 0,
        admin2ID: Int? = nil,
        admin3ID: Int? = nil,
        admin4ID: Int? = nil,
        timezone: String = "UTC",
        population: Int? = nil,
        postcodes: [String]? = nil,
        countryID: Int = 0,
        country: String = "Unknown",
        admin1: String = "Unknown",
        admin2: String? = nil,
        admin3: String? = nil,
        admin4: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.elevation = elevation
        self.featureCode = featureCode
        self.countryCode = countryCode
        self.admin1ID = admin1ID
        self.admin2ID = admin2ID
        self.admin3ID = admin3ID
        self.admin4ID = admin4ID
        self.timezone = timezone
        self.population = population
        self.postcodes = postcodes
        self.countryID = countryID
        self.country = country
        self.admin1 = admin1
        self.admin2 = admin2
        self.admin3 = admin3
        self.admin4 = admin4
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

    init(
        city: City? = nil,
        current: CurrentData? = nil,
        hourly: HourlyData? = nil,
        daily: WeeklyData? = nil
    ) {
        self.city = city
        self.current = current
        self.hourly = hourly
        self.daily = daily
    }
}

struct CurrentData: Codable {
    var time: String
    var temperature_2m: Double
    var is_day: Int8
    var weather_code: Int8
    var wind_speed_10m: Double
    
    init(
        time: String = "",
        temperature_2m: Double = 0.0,
        is_day: Int8 = 0,
        weather_code: Int8 = 0,
        wind_speed_10m: Double = 0.0
    ) {
        self.time = time
        self.temperature_2m = temperature_2m
        self.is_day = is_day
        self.weather_code = weather_code
        self.wind_speed_10m = wind_speed_10m
    }
}

struct HourlyData: Codable {
    var time: Array<String>
    var temperature_2m: Array<Double>
    var weather_code: Array<Int8>
    var wind_speed_10m: Array<Double>
    
    init(
        time: [String] = [],
        temperature_2m: [Double] = [],
        weather_code: [Int8] = [],
        wind_speed_10m: [Double] = []
    ) {
        self.time = time
        self.temperature_2m = temperature_2m
        self.weather_code = weather_code
        self.wind_speed_10m = wind_speed_10m
    }
}

struct WeeklyData: Codable {
    var time: Array<String>
    var weather_code: Array<Int8>
    var temperature_2m_max: Array<Double>
    var temperature_2m_min: Array<Double>
    
    init(
        time: [String] = [],
        weather_code: [Int8] = [],
        temperature_2m_max: [Double] = [],
        temperature_2m_min: [Double] = []
    ) {
        self.time = time
        self.weather_code = weather_code
        self.temperature_2m_max = temperature_2m_max
        self.temperature_2m_min = temperature_2m_min
    }
}

struct HourlyEntry: Identifiable {
    var id = UUID()
    var hour: String
    var temperature: Double
}

struct WeeklyEntry: Identifiable {
    var id = UUID()
    var day: String
    var temperature_max: Double
    var temperature_min: Double
}

// Structure pour l"interprétation WMO
struct WMOInterpretation {
    let color: Color
    let description: String
    let isDarkText: Bool
    let icon: String

    init(color: String, description: String, icon: String) {
        self.color = Color(hex: color) // Vous devrez ajouter un initialiseur personnalisé pour Color hex
        self.description = description
        self.icon = "\(icon)"

        // Détection de contraste pour définir la couleur du texte
        let colorBackground = UIColor(Color(hex: color))
        self.isDarkText = colorBackground.isDarkText()
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hex)
        
        if hex.hasPrefix("#") {
            scanner.currentIndex = hex.index(after: hex.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

extension UIColor {
    func isDarkText() -> Bool {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let brightness = ((red * 299) + (green * 587) + (blue * 114)) / 1000
        return brightness < 0.5
    }
}

let WMO_CODES: [Int8: WMOInterpretation] = [
    0: WMOInterpretation(color: "#F1F1F1", description: "Clear", icon: "clear"),
    1: WMOInterpretation(color: "#E2E2E2", description: "Mostly Clear", icon: "mostly-clear"),
    2: WMOInterpretation(color: "#C6C6C6", description: "Partly Cloudy", icon: "partly-cloudy"),
    3: WMOInterpretation(color: "#ABABAB", description: "Overcast", icon: "overcast"),
    

    45: WMOInterpretation(color:"#A4ACBA", description:"Fog", icon:"fog"),
    48: WMOInterpretation(color:"#8891A4", description:"Icy Fog", icon:"rime-fog"),

    51: WMOInterpretation(color:"#3DECEB", description:"Light Drizzle", icon:"light-drizzle"),
    53: WMOInterpretation(color:"#0CCECE", description:"Drizzle", icon:"moderate-drizzle"),
    55: WMOInterpretation(color:"#0AB1B1", description:"Heavy Drizzle", icon:"dense-drizzle"),

    80: WMOInterpretation(color:"#9BCCFD", description:"Light Showers", icon:"light-rain"),
    81: WMOInterpretation(color:"#51B4FF", description:"Showers", icon:"moderate-rain"),
    82: WMOInterpretation(color:"#029AE8", description:"Heavy Showers", icon:"heavy-rain"),

    61: WMOInterpretation(color:"#BFC3FA", description:"Light Rain", icon:"light-rain"),
    63: WMOInterpretation(color:"#9CA7FA", description:"Rain", icon:"moderate-rain"),
    65: WMOInterpretation(color:"#748BF8", description:"Heavy Rain", icon:"heavy-rain"),

    56: WMOInterpretation(color:"#D3BFE8", description:"Light Freezing Drizzle", icon:"light-freezing-drizzle"),
    57: WMOInterpretation(color:"#A780D4", description:"Freezing Drizzle", icon:"dense-freezing-drizzle"),

    66: WMOInterpretation(color:"#CAC1EE", description:"Light Freezing Rain", icon:"light-freezing-rain"),
    67: WMOInterpretation(color:"#9486E1", description:"Freezing Rain", icon:"heavy-freezing-rain"),

    71: WMOInterpretation(color:"#F9B1D8", description:"Light Snow", icon:"slight-snowfall"),
    73: WMOInterpretation(color:"#F983C7", description:"Snow", icon:"moderate-snowfall"),
    75: WMOInterpretation(color:"#F748B7", description:"Heavy Snow", icon:"heavy-snowfall"),

    77: WMOInterpretation(color:"#E7B6EE", description:"Snow Grains", icon:"snowflake"),

    85: WMOInterpretation(color:"#E7B6EE", description:"Light Snow Showers", icon:"slight-snowfall"),
    86: WMOInterpretation(color:"#CD68E0", description:"Snow Showers", icon:"heavy-snowfall"),

    95: WMOInterpretation(color:"#525F7A", description:"Thunderstorm", icon:"thunderstorm"),

    96: WMOInterpretation(color:"#3D475C", description:"Light T-storm w/ Hail", icon:"thunderstorm-with-hail"),
    99: WMOInterpretation(color:"#2A3140", description:"T-storm w/ Hail", icon:"thunderstorm-with-hail")
]

struct weatherIcons {
    static let data: [String: String] = [
        "Sunny": "sun.max",
        "Mainly Sunny": "sun.min",
        "Partly Cloudy": "cloud.sun.fill",
        "Cloudy": "cloud.fill",
        "Foggy": "cloud.fog",
        "Rime Fog": "cloud.fog.fill",
        "Light Drizzle": "cloud.drizzle",
        "Drizzle": "cloud.drizzle.fill",
        "Heavy Drizzle": "cloud.drizzle.circle.fill",
        "Light Freezing Drizzle": "cloud.sleet",
        "Freezing Drizzle": "cloud.sleet.fill",
        "Light Rain": "cloud.rain",
        "Rain": "cloud.rain.fill",
        "Heavy Rain": "cloud.heavyrain",
        "Light Freezing Rain": "cloud.sleet",
        "Freezing Rain": "cloud.sleet.fill",
        "Light Snow": "snowflake",
        "Snow": "snowflake",
        "Heavy Snow": "snowflake",
        "Snow Grains": "cloud.hail",
        "Light Showers": "cloud.rain",
        "Showers": "cloud.rain",
        "Heavy Showers": "cloud.rain",
        "Light Snow Showers": "cloud.snow.fill",
        "Snow Showers": "cloud.snow.fill",
        "Thunderstorm": "cloud.bolt.rain.fill",
        "Light Thunderstorms With Hail": "cloud.bolt.rain.fill",
        "Thunderstorm With Hail": "cloud.bolt.rain.fill"
    ]
}

