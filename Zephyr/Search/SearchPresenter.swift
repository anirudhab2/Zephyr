//
//  SearchPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//  
//

import Foundation

// MARK: - SearchPresentable
protocol SearchPresentable {
    func handleCancelAction()
    func search(text: String)
    func numberOfItems() -> Int
    func titleForSearchResult(atIndex index: Int) -> String?
    func handleSelection(atIndex index: Int)
}

// MARK: - SearchPresenter
final class SearchPresenter {

    weak var view: SearchViewable?

    private let interactor: SearchInteractable
    private let router: SearchRoutable
    private let debouncer: DebounceWorker

    private var searchResults: RemoteModel<[SearchResult], HttpError> = .notFetched {
        didSet {
            searchResultsUpdated(to: searchResults)
        }
    }

    init(
        interactor: SearchInteractable,
        router: SearchRoutable
    ) {
        self.interactor = interactor
        self.router = router
        self.debouncer = DebounceWorker(queue: .main, interval: 0.3)
    }
}

// MARK: - Helpers
extension SearchPresenter {
    private func searchResult(atIndex index: Int) -> SearchResult? {
        guard case .fetched(let results) = searchResults,
              results.indices.contains(index) else {
            return nil
        }
        return results[index]
    }

    private func searchResultsUpdated(to result: RemoteModel<[SearchResult], HttpError>) {
        switch result {
        case .notFetched:
            view?.renderContents()

        case .fetching:
            view?.renderLoading()

        case .fetched(let results):
            if results.isEmpty {
                fallthrough
            }
            view?.renderContents()

        case .failed:
            view?.renderError(message: "No results found")
        }
    }
}

// MARK: SearchPresentable
extension SearchPresenter: SearchPresentable {
    func handleCancelAction() {
        router.navigateBack(with: nil)
    }

    func search(text: String) {
        if text.isEmpty {
            searchResults = .notFetched
            return
        }
        debouncer.cancel()
        interactor.cancelInProgressSearch()
        debouncer.debounce { [weak self] in
            self?.interactor.search(text: text)
        }
    }

    func numberOfItems() -> Int {
        guard case .fetched(let results) = searchResults else {
            return 0
        }
        return results.count
    }

    func titleForSearchResult(atIndex index: Int) -> String? {
        guard let result = searchResult(atIndex: index) else {
            return nil
        }
        return [result.name, result.state, result.country].compactMap({ $0 }).joined(separator: ", ")
    }

    func handleSelection(atIndex index: Int) {
        guard let result = searchResult(atIndex: index) else {
            return
        }
        router.navigateBack(with: result.location)
    }
}

// MARK: SearchInteractorListener
extension SearchPresenter: SearchInteractorListener {
    func didFetchSearchResults(_ results: [SearchResult]) {
        searchResults = .fetched(results)
    }

    func didFailToFetchSearchResults(with error: HttpError) {
        searchResults = .failed(error)
    }
}
