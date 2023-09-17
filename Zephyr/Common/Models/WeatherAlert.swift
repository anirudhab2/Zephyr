//
//  WeatherAlert.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct WeatherAlert {
    let sender: String
    let event: String
    let start: Int
    let end: Int
    let description: String
}

// MARK: - WeatherAlert + Codable
extension WeatherAlert: Codable {
    private enum CodingKeys: String, CodingKey {
        case sender = "sender_name"
        case event
        case start
        case end
        case description
    }
}
