//
//  WeatherData.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct WeatherData {

    typealias Time = Float
    typealias Temperature = Float

    let currentTime: Time
    let sunrise: Time
    let sunset: Time

    let temperature: Temperature
    let feelsLike: Temperature

    let pressure: Float
    let humidity: Float
    let dewPoint: Temperature
    let clouds: Float
    let uvIndex: Float

    let displayInformation: [DisplayInformation]
}

// MARK: - WeatherData + Codable
extension WeatherData: Codable {
    private enum CodingKeys: String, CodingKey {
        case currentTime = "dt"
        case sunrise
        case sunset

        case temperature = "temp"
        case feelsLike = "feels_like"

        case pressure
        case humidity
        case dewPoint = "dew_point"
        case clouds
        case uvIndex = "uvi"

        case displayInformation = "weather"
    }
}

// MARK: - WeatherData + DisplayInformation
extension WeatherData {
    struct DisplayInformation {
        let id: Int
        let conditions: String
        let description: String
        let icon: String
    }
}

// MARK: - WeatherData.DisplayInformation + Codable
extension WeatherData.DisplayInformation: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case conditions = "main"
        case description
        case icon
    }
}
