//
//  Timezone.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct Timezone {
    let name: String
    let offset: Int
}

extension Timezone: Codable {
    private enum CodingKeys: String, CodingKey {
        case name = "timezone"
        case offset = "timezone_offset"
    }
}
