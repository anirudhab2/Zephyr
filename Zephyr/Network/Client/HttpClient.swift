//
//  HttpClient.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

protocol HttpClient {
    var baseURL: URL { get }
    var session: URLSession { get }

    @discardableResult
    func perform<Model: Decodable>(
        request: HttpRequest,
        decodeAs: Model.Type,
        completion: @escaping (Result<Model, HttpError>) -> Void
    ) -> URLSessionTask?
}

// MARK: - Default Implementation
extension HttpClient {
    var baseURL: URL {
        Constants.Networking.baseURL
    }

    var session: URLSession {
        URLSession.shared
    }

    @discardableResult
    func perform<Model: Decodable>(
        request: HttpRequest,
        decodeAs: Model.Type,
        completion: @escaping (Result<Model, HttpError>) -> Void
    ) -> URLSessionTask? {
        let urlRequest = request.makeRequest(withBaseURL: baseURL)
        let task = perform(request: urlRequest) { result in
            let parsedResult: Result<Model, HttpError> = result.flatMap { data in
                do {
                    let model = try JSONDecoder().decode(decodeAs.self, from: data)
                    return .success(model)
                } catch let error as DecodingError {
                    return .failure(.decodingFailure(error))
                } catch {
                    return .failure(.invalidData)
                }
            }
            DispatchQueue.main.async {
                completion(parsedResult)
            }
        }
        return task
    }
}

// MARK: - Helpers
extension HttpClient {
    private func perform(
        request: URLRequest?,
        completion: @escaping (Result<Data, HttpError>) -> Void
    ) -> URLSessionTask? {
        guard let request else {
            completion(.failure(.invalidRequest))
            return nil
        }

        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            debugLog(request: request, responseData: data, error: error)
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed))
                return
            }
            let statusCode = httpResponse.statusCode
            if let data,
               Constants.Networking.successStatusCodes.contains(statusCode) {
                completion(.success(data))
            } else {
                if let urlError = error as? URLError,
                   urlError.code == .cancelled {
                    // Manually cancelled, don't throw errorsa
                    return
                }
                completion(.failure(.responseFailure(statusCode: statusCode)))
            }
        }

        task.resume()
        return task
    }

    private func debugLog(request: URLRequest, responseData: Data?, error: Error?) {
        Logger.debug.log(message: "Request:\n\(request.cURLString())", category: .networking)
        let responseLog: () -> String = {
            let resp = responseData.map({ try? JSONSerialization.jsonObject(with: $0, options: .allowFragments) })
            return "Response: \n\(String(describing: resp ?? "nil"))"
        }
        Logger.debug.log(message: responseLog(), category: .networking)
        Logger.debug.log(message: "Error: \(String(describing: error))", category: .networking)
    }
}
