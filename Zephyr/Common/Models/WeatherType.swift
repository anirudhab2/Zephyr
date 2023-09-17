//
//  WeatherType.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

enum WeatherType {
    case clearSky(IconVariant)
    case fewClouds(IconVariant)
    case scatteredClouds(IconVariant)
    case brokenClouds(IconVariant)
    case showerRain(IconVariant)
    case rain(IconVariant)
    case thunderstorm(IconVariant)
    case snow(IconVariant)
    case mist(IconVariant)

    enum IconVariant: String {
        case day
        case night
    }

    init?(iconCode: String) {
        switch iconCode {
        case "01d":
            self = .clearSky(.day)
        case "01n":
            self = .clearSky(.night)
        case "02d":
            self = .fewClouds(.day)
        case "02n":
            self = .fewClouds(.night)
        case "03d":
            self = .scatteredClouds(.day)
        case "03n":
            self = .scatteredClouds(.night)
        case "04d":
            self = .brokenClouds(.day)
        case "04n":
            self = .brokenClouds(.night)
        case "09d":
            self = .showerRain(.day)
        case "09n":
            self = .showerRain(.night)
        case "10d":
            self = .rain(.day)
        case "10n":
            self = .rain(.night)
        case "11d":
            self = .thunderstorm(.day)
        case "11n":
            self = .thunderstorm(.night)
        case "13d":
            self = .snow(.day)
        case "13n":
            self = .snow(.night)
        case "50d":
            self = .mist(.day)
        case "50n":
            self = .mist(.night)
        default:
            return nil
        }
    }
}

extension WeatherType {
    func asset() -> UIImage? {
        switch self {

        case .clearSky(.day):
            return Assets.Clear.sun
        case .clearSky(.night):
            return Assets.Clear.moon
        case .fewClouds(.day):
            return Assets.Clouds.withSun
        case .fewClouds(.night):
            return Assets.Clouds.withMoon
        case .scatteredClouds(_):
            return Assets.Clouds.full
        case .brokenClouds(_):
            return Assets.Clouds.full
        case .showerRain(_):
            return Assets.Rain.showers
        case .rain(.day):
            return Assets.Rain.withSun
        case .rain(.night):
            return Assets.Rain.withMoon
        case .thunderstorm(_):
            return Assets.Others.thunderstorm
        case .snow(_):
            return Assets.Others.snow
        case .mist(_):
            return Assets.Others.fog
        }
    }
}
