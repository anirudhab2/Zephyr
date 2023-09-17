//
//  HttpRequest.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

protocol HttpRequest {
    typealias QueryParams = [String: String]
    typealias Headers = [String: String]
    
    var path: String { get }
    var method: HttpMethod { get }
    var queryParams: QueryParams? { get }
    var headers: Headers? { get }
    var body: HttpRequestBody { get }
    
    func makeRequest(withBaseURL baseURL: URL) -> URLRequest?
}

// MARK: - Default Implementation
extension HttpRequest {
    var method: HttpMethod {
        .get
    }
    
    var queryParams: QueryParams {
        [:]
    }
    
    var headers: Headers {
        [:]
    }
    
    var body: HttpRequestBody {
        .none
    }
    
    func makeRequest(withBaseURL baseURL: URL) -> URLRequest? {
        let fullPath: String = {
            var basePath = baseURL.absoluteString
            let forwardSlash = "/"
            switch (basePath.hasSuffix(forwardSlash), path.hasPrefix(forwardSlash)) {
                case (true, false),
                (false, true):
                break
                
            case (false, false):
                basePath += forwardSlash
                
            case (true, true):
                basePath.removeLast()
            }
            return basePath + path
        }()
        
        guard var components = URLComponents(string: fullPath) else {
            return nil
        }
        var queryParams = queryParams ?? [:]
        queryParams[Constants.Networking.Params.apiKey] = Constants.App.apiKey
        components.queryItems = queryParams.map({ URLQueryItem(name: $0, value: $1) })
        
        guard let url = components.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = {
            switch body {
            case .none:
                return nil
            case .data(let data):
                return data
            case .jsonArray(let array):
                return try? JSONSerialization.data(withJSONObject: array)
            case .jsonDictionary(let dictionary):
                return try? JSONSerialization.data(withJSONObject: dictionary)
            }
        }()
        return request
    }
}
