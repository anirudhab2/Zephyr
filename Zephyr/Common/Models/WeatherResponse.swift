//
//  WeatherResponse.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct WeatherResponse: Codable {
    let coord: Location
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let rain: Rain?
    let snow: Rain?
    let clouds: Clouds
    let dt: Double
    let sys: Sys
    let timezone, id: Int
    let name: String
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike: Double
        let tempMin, tempMax: Double?
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double?
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

