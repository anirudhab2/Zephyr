//
//  WeatherConditions.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import Foundation

enum WeatherConditions {
    case clear
    case clouds
    case drizzle
    case rain
    case thunderstorm
    case snow
    case atmosphere

    init?(weatherId: Int) {
        switch weatherId {
        case 200...299:
            self = .thunderstorm

        case 300...399:
            self = .drizzle

        case 500...599:
            self = .rain

        case 600...699:
            self = .snow

        case 700...799:
            self = .atmosphere

        case 800:
            self = .clear

        case 801...899:
            self = .clouds

        default:
            return nil
        }
    }
}

extension WeatherConditions {
    enum CloudConditions: Int {
        case few = 801
        case scattered = 802
        case broken = 803
        case overcast = 804
    }
}
