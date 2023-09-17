//
//  SearchViewController.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//  
//

import UIKit

// MARK: - SearchViewable
protocol SearchViewable: AnyObject {
    func renderContents()
    func renderError(message: String)
    func renderLoading()
}

// MARK: - SearchViewController
final class SearchViewController: UIViewController {

    private let presenter: SearchPresentable
    private weak var loadingView: UIActivityIndicatorView?
    private weak var errorView: UIView?

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.autocapitalizationType = .none
        bar.autocorrectionType = .no
        bar.placeholder = "Find location"
        bar.showsCancelButton = true
        bar.delegate = self
        bar.tintColor = Colors.Named.white
        bar.searchTextField.tintColor = Colors.Named.white
        bar.searchTextField.textColor = Colors.Named.white
        return bar
    }()

    private lazy var tableView: UITableView = {
        let t = UITableView()
        t.separatorStyle = .none
        t.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseIdentifier)
        t.dataSource = self
        t.delegate = self
        return t
    }()

    // MARK: - Init/Deinit
    init(presenter: SearchPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
}

// MARK: - Layout
extension SearchViewController {
    private func setupLayout() {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blur.fill(in: view)
        view.backgroundColor = nil
        tableView.backgroundColor = nil
        navigationItem.titleView = searchBar
        tableView.fill(in: view)
    }
}

// MARK: - Helpers
extension SearchViewController {
    private func showLoading() {
        guard loadingView == nil else { return }

        let loader = UIActivityIndicatorView(style: .large)
        loader.tintColor = Colors.Named.white
        loader.fill(in: view)
        loader.startAnimating()
        self.loadingView = loader
    }

    private func removeLoading() {
        loadingView?.stopAnimating()
        loadingView?.removeFromSuperview()
    }

    private func showError(message: String) {
        removeError()
        let errorView = WeatherErrorView()
        errorView.configure(title: "", message: message)
        errorView.fill(in: view)
        self.errorView = errorView
    }

    private func removeError() {
        errorView?.removeFromSuperview()
    }

    private func showContent() {
        tableView.isHidden = false
    }

    private func hideContent() {
        tableView.isHidden = true
    }
}

// MARK: - SearchViewable
extension SearchViewController: SearchViewable {
    func renderContents() {
        removeError()
        removeLoading()
        showContent()
        tableView.reloadData()
    }

    func renderError(message: String) {
        hideContent()
        removeLoading()
        showError(message: message)
    }

    func renderLoading() {
        hideContent()
        removeError()
        showLoading()
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.reuseIdentifier, for: indexPath)
        if let cell = cell as? SearchResultCell {
            cell.text = presenter.titleForSearchResult(atIndex: indexPath.row)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.handleSelection(atIndex: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.handleCancelAction()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.search(text: searchText)
    }
}
