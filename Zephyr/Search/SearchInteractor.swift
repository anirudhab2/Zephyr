//
//  SearchInteractor.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//  
//

import Foundation

// MARK: - SearchInteractable
protocol SearchInteractable {
    func search(text: String)
    func cancelInProgressSearch()
}

// MARK: - SearchInteractorListener
protocol SearchInteractorListener: AnyObject {
    func didFetchSearchResults(_ results: [SearchResult])
    func didFailToFetchSearchResults(with error: HttpError)
}

// MARK: - SearchInteractor
final class SearchInteractor {
    weak var listener: SearchInteractorListener?
    private let client = GenericHttpClient()
    private var currentSearchTask: URLSessionTask?
}

// MARK: SearchInteractable
extension SearchInteractor: SearchInteractable {
    func search(text: String) {
        cancelInProgressSearch()

        let request = GenericHttpRequest(
            path: Constants.Networking.Paths.locationSearch,
            queryParams: [
                Constants.Networking.Params.searchQuery: text,
                Constants.Networking.Params.limit: String(5)
            ]
        )
        currentSearchTask = client.perform(request: request, decodeAs: [SearchResult].self) { [weak self] result in
            switch result {
            case .success(let results):
                self?.listener?.didFetchSearchResults(results)
            case .failure(let error):
                self?.listener?.didFailToFetchSearchResults(with: error)
            }
        }
    }

    func cancelInProgressSearch() {
        currentSearchTask?.cancel()
        currentSearchTask = nil
    }
}
