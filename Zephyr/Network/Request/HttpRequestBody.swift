//
//  HttpRequestBody.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum HttpRequestBody {
    case none
    case jsonArray([Any])
    case jsonDictionary([String: Any])
    case data(Data)
}
