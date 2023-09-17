//
//  GenericHttpRequest.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

struct GenericHttpRequest: HttpRequest {
    let path: String
    let method: HttpMethod
    let queryParams: QueryParams?
    let headers: Headers?
    let body: HttpRequestBody

    init(
        path: String,
        method: HttpMethod = .get,
        queryParams: GenericHttpRequest.QueryParams? = nil,
        headers: GenericHttpRequest.Headers? = nil,
        body: HttpRequestBody = .none
    ) {
        self.path = path
        self.method = method
        self.queryParams = queryParams
        self.headers = headers
        self.body = body
    }
}
