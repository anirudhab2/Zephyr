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
    func refreshContents()
    func renderError()
}

// MARK: - SearchViewController
final class SearchViewController: UIViewController {

    private let presenter: SearchPresentable

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.autocapitalizationType = .none
        bar.autocorrectionType = .no
        bar.placeholder = "Find location"
        bar.showsCancelButton = true
        bar.delegate = self
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
        view.backgroundColor = Colors.Background.primary
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
        navigationItem.titleView = searchBar
        tableView.fill(in: view)
    }
}

// MARK: - SearchViewable
extension SearchViewController: SearchViewable {
    func refreshContents() {
        tableView.reloadData()
    }

    func renderError() {

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
