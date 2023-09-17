//
//  Preferences.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import Foundation

final class Preferences {
    var units: Units {
        get {
            let rawValue = UserDefaults.standard.string(forKey: Constants.UserDefaultsKeys.units)
            return rawValue.flatMap(Units.init(rawValue:)) ?? .metric
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.UserDefaultsKeys.units)
        }
    }

    var location: Location? {
        get {
            guard let data = UserDefaults.standard.data(forKey: Constants.UserDefaultsKeys.location) else {
                return nil
            }
            return try? JSONDecoder().decode(Location.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                return
            }
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultsKeys.location)
        }
    }
}
