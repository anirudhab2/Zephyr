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
            UIImage(systemName: "sun.max.fill")
        }

        static var moon: UIImage? {
            UIImage(systemName: "moon.fill")
        }
    }

    enum Clouds {
        static var withSun: UIImage? {
            UIImage(systemName: "cloud.sun.fill")
        }

        static var withMoon: UIImage? {
            UIImage(systemName: "cloud.moon.fill")
        }

        static var full: UIImage? {
            UIImage(systemName: "cloud.fill")
        }
    }

    enum Rain {
        static var withSun: UIImage? {
            UIImage(systemName: "cloud.sun.rain.fill")
        }

        static var withMoon: UIImage? {
            UIImage(systemName: "cloud.moon.rain.fill")
        }

        static var showers: UIImage? {
            UIImage(systemName: "cloud.rain.fill")
        }
    }

    enum Others {
        static var fog: UIImage? {
            UIImage(systemName: "cloud.fog.fill")
        }

        static var snow: UIImage? {
            UIImage(systemName: "snowflake")
        }

        static var thunderstorm: UIImage? {
            UIImage(systemName: "cloud.bolt.rain.fill")
        }

        static var humidity: UIImage? {
            UIImage(systemName: "humidity.fill")
        }

        static var pressure: UIImage? {
            UIImage(systemName: "arrow.down")
        }

        static var sunrise: UIImage? {
            UIImage(systemName: "sunrise.fill")
        }

        static var sunset: UIImage? {
            UIImage(systemName: "sunset.fill")
        }

        static var apparentTemperature: UIImage? {
            UIImage(systemName: "thermometer.medium")
        }

        static var visibility: UIImage? {
            UIImage(systemName: "eye.fill")
        }

        static var wind: UIImage? {
            UIImage(systemName: "wind")
        }
    }
}
