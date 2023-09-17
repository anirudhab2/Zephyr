//
//  WeatherInformation.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct WeatherInformation {
    let location: LocationInfo
    let timeInfo: TimeInfo
    let weather: WeatherData

    init(
        location: LocationInfo,
        timeInfo: TimeInfo,
        weather: WeatherData
    ) {
        self.location = location
        self.timeInfo = timeInfo
        self.weather = weather
    }
}

extension WeatherInformation {
    struct LocationInfo {
        let coordinates: Location
        let countryCode: String
        let cityName: String
    }
}

extension WeatherInformation {
    struct TimeInfo {
        let current: Date
        let timeZoneShift: Int
    }
}

extension WeatherInformation {
    struct WeatherData {
        let humidity: Int
        let visibility: Int
        let displayInfo: DisplayInformation?
        let temperature: TemperatureInfo
        let pressure: PressureInfo
        let wind: WindInfo
        let sun: SunInfo
        let rain: PrecipitationInfo?
        let snow: PrecipitationInfo?
    }
}

extension WeatherInformation {
    struct DisplayInformation {
        let id: Int
        let conditions: String
        let description: String
        let icon: String
    }
}

extension WeatherInformation {
    struct TemperatureInfo {
        typealias Temperature = Double

        let current: Temperature
        let feelsLike: Temperature
        let min: Temperature?
        let max: Temperature?
    }
}

extension WeatherInformation {
    struct PressureInfo {
        typealias Pressure = Int

        let current: Pressure
        let seaLevel: Pressure?
        let groundLevel: Pressure?
    }
}

extension WeatherInformation {
    struct WindInfo {
        let speed: Double
        let direction: Int
        let gust: Double?
    }
}

extension WeatherInformation {
    struct CloudsInfo {
        let all: Int
    }
}

extension WeatherInformation {
    struct SunInfo {
        let sunrise: Date
        let sunset: Date
    }
}

extension WeatherInformation {
    struct PrecipitationInfo {
        let lastHour: Double
        let lastThreeHours: Double?
    }
}

extension WeatherInformation {
    init(response: WeatherResponse) {
        let displayInfo: DisplayInformation? = {
            guard let info = response.weather.first else {
                return nil
            }
            return .init(
                id: info.id,
                conditions: info.main,
                description: info.description,
                icon: info.icon
            )
        }()

        let tempInfo = TemperatureInfo(
            current: response.main.temp,
            feelsLike: response.main.feelsLike,
            min: response.main.tempMin,
            max: response.main.tempMax
        )

        let pressureInfo = PressureInfo(
            current: response.main.pressure,
            seaLevel: response.main.seaLevel,
            groundLevel: response.main.grndLevel
        )

        let windInfo = WindInfo(
            speed: response.wind.speed,
            direction: response.wind.deg,
            gust: response.wind.gust
        )

        let sunInfo = SunInfo(
            sunrise: Date(timeIntervalSince1970: response.sys.sunrise),
            sunset: Date(timeIntervalSince1970: response.sys.sunset)
        )

        func precipitationInfo(from info: Rain?) -> PrecipitationInfo? {
            guard let lastHour = info?.the1H else {
                return nil
            }
            return PrecipitationInfo(
                lastHour: lastHour,
                lastThreeHours: info?.the3H
            )
        }

        let rainInfo = precipitationInfo(from: response.rain)
        let snowInfo = precipitationInfo(from: response.snow)

        let weather = WeatherData(
            humidity: response.main.humidity,
            visibility: response.visibility,
            displayInfo: displayInfo,
            temperature: tempInfo,
            pressure: pressureInfo,
            wind: windInfo,
            sun: sunInfo,
            rain: rainInfo,
            snow: snowInfo
        )

        let location = LocationInfo(
            coordinates: response.coord,
            countryCode: response.sys.country,
            cityName: response.name
        )

        let time = TimeInfo(
            current: Date(timeIntervalSince1970: response.dt),
            timeZoneShift: response.timezone
        )

        self.init(
            location: location,
            timeInfo: time,
            weather: weather
        )
    }
}
