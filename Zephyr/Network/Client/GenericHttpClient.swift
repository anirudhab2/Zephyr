//
//  GenericHttpClient.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct GenericHttpClient: HttpClient {
    let baseURL: URL

    init(baseURL: URL = Constants.Networking.baseURL) {
        self.baseURL = baseURL
    }
}
