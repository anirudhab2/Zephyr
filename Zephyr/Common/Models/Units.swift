//
//  Units.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum Units: String, Codable {
    case metric     // metric units, Celsius
    case imperial   // Imperial units, Fahrenheit

    func suffix() -> String {
        switch self {
        case .metric:
            return "°C"
        case .imperial:
            return "°F"
        }
    }
}

// MARK: - Units + URLQueryConvertible
extension Units: URLQueryConvertible {
    func asQueryParams() -> [String : String] {
        [Constants.Networking.Params.units: self.rawValue]
    }
}

