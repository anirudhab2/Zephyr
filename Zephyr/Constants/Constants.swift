//
//  Constants.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum Constants {
    enum App {
        // I'm aware that we aren't supposed to hardcode secrets in public repo
        // Letting it slide since it's a demo app
        // In production apps we have better ways to handle this
        static let apiKey = "d200ac1151d96e32428ce0628e511a46"

        static let bundleIdentifier = Bundle.main.bundleIdentifier ?? "com.anirudha.zephyr"
    }
}

extension Constants {
    enum UserDefaultsKeys {
        static let units = App.bundleIdentifier + "units"
        static let location = App.bundleIdentifier + "location"
    }
}

extension Constants {
    enum Networking {
        // Safe to use implicitely unwrapped optionals, as this is a valid URL
        static let baseURL = URL(string: "https://api.openweathermap.org")!
        static let successStatusCodes = (200...299)
        
        enum Paths {
            static let weatherData = "/data/2.5/weather"
            static let locationSearch = "/geo/1.0/direct"
        }
    }
}

extension Constants.Networking {
    enum Params {
        static let apiKey = "appid"
        static let limit = "limit"
        static let searchQuery = "q"
        static let units = "units"
    }
}
