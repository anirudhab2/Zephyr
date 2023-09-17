//
//  Location.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct Location {
    let latitude: Double
    let longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// MARK: - Location + Codable
extension Location: Codable {
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

// MARK: - Location + URLQueryConvertible
extension Location: URLQueryConvertible {
    func asQueryParams() -> [String : String] {
        [
            CodingKeys.latitude.rawValue: String(latitude),
            CodingKeys.longitude.rawValue: String(longitude)
        ]
    }
}

// MARK: - Location + CustomStringConvertible
extension Location: CustomStringConvertible {
    var description: String {
        "latitude: \(latitude), longitude: \(longitude)"
    }
}
