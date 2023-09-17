//
//  SearchResult.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import Foundation

struct SearchResult {
    let name: String
    let state: String?
    let country: String?
    let location: Location
}

// MARK: - Decodable
extension SearchResult: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name, state, country
    }

    init(from decoder: Decoder) throws {
        location = try Location(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        state = try container.decodeIfPresent(String.self, forKey: .state)
        country = try container.decodeIfPresent(String.self, forKey: .country)
    }
}
