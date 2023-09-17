//
//  URLQueryConvertible.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

protocol URLQueryConvertible {
    func asQueryParams() -> HttpRequest.QueryParams
}
