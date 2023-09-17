//
//  Assets.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

enum Assets {
    static var location: UIImage? {
        UIImage(systemName: "location")
    }
}

extension Assets {
    enum Clear {
        static var sun: UIImage? {
            UIImage(systemName: "sun.max")
        }

        static var moon: UIImage? {
            UIImage(systemName: "moon")
        }
    }

    enum Clouds {
        static var withSun: UIImage? {
            UIImage(systemName: "cloud.sun")
        }

        static var withMoon: UIImage? {
            UIImage(systemName: "cloud.moon")
        }

        static var full: UIImage? {
            UIImage(systemName: "cloud")
        }
    }

    enum Rain {
        static var withSun: UIImage? {
            UIImage(systemName: "cloud.sun.rain")
        }

        static var withMoon: UIImage? {
            UIImage(systemName: "cloud.moon.rain")
        }

        static var showers: UIImage? {
            UIImage(systemName: "cloud.rain")
        }
    }

    enum Others {
        static var fog: UIImage? {
            UIImage(systemName: "cloud.fog")
        }

        static var snow: UIImage? {
            UIImage(systemName: "snowflake")
        }

        static var thunderstorm: UIImage? {
            UIImage(systemName: "cloud.bolt.rain")
        }

        static var humidity: UIImage? {
            UIImage(systemName: "humidity")
        }

        static var pressure: UIImage? {
            UIImage(systemName: "barometer")
        }

        static var sunrise: UIImage? {
            UIImage(systemName: "sunrise")
        }

        static var sunset: UIImage? {
            UIImage(systemName: "sunset")
        }

        static var apparentTemperature: UIImage? {
            UIImage(systemName: "thermometer.medium")
        }

        static var visibility: UIImage? {
            UIImage(systemName: "eye")
        }

        static var wind: UIImage? {
            UIImage(systemName: "wind")
        }
    }
}
