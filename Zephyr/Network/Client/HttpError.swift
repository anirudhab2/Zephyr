//
//  HttpError.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum HttpError: Error {
    case invalidRequest
    case requestFailed
    case invalidData
    case decodingFailure(DecodingError)
    case responseFailure(statusCode: Int)
}
