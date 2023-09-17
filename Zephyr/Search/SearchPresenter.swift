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
    private var searchResults: [SearchResult] = []

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
        guard searchResults.indices.contains(index) else {
            return nil
        }
        return searchResults[index]
    }
}

// MARK: SearchPresentable
extension SearchPresenter: SearchPresentable {
    func handleCancelAction() {
        router.navigateBack(with: nil)
    }

    func search(text: String) {
        debouncer.cancel()
        interactor.cancelInProgressSearch()
        debouncer.debounce { [weak self] in
            self?.interactor.search(text: text)
        }
    }

    func numberOfItems() -> Int {
        searchResults.count
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
        searchResults = results
        view?.refreshContents()
    }

    func didFailToFetchSearchResults(with error: HttpError) {
        view?.renderError()
    }
}
