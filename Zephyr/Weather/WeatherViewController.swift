//
//  WeatherViewController.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import UIKit

// MARK: - WeatherViewable
protocol WeatherViewable: AnyObject {
    func renderLoading()
    func renderError(with info: WeatherErrorView.ErrorInfo)
    func renderContent()
}

// MARK: - WeatherViewController
final class WeatherViewController: UIViewController {

    private let presenter: WeatherPresentable
    private let style: Style

    private weak var loadingView: UIActivityIndicatorView?
    private weak var errorView: WeatherErrorView?

    private lazy var unitsBarItem: UIBarButtonItem = {
        let b = UIBarButtonItem(
            title: presenter.unitSymbol(),
            style: .plain,
            target: self,
            action: #selector(unitTapped)
        )
        b.tintColor = Colors.Text.primary
        return b
    }()

    private lazy var searchBarItem: UIBarButtonItem = {
        let b = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(searchTapped)
        )
        b.tintColor = Colors.Text.primary
        return b
    }()

    private lazy var locationBarItem: UIBarButtonItem = {
        let b = UIBarButtonItem(
            image: Assets.location,
            style: .plain,
            target: self,
            action: #selector(locationTapped)
        )
        b.tintColor = Colors.Text.primary
        return b
    }()

    private lazy var layout: UICollectionViewLayout = {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(30)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(30)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 1
            )

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = self.style.interItemSpacing
            section.contentInsets = self.style.contentInsets
            return section
        }
    }()

    private lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: .zero, collectionViewLayout: layout)
        c.backgroundColor = .clear
        c.register(WeatherPrimaryInfoCell.self, forCellWithReuseIdentifier: WeatherPrimaryInfoCell.reuseIdentifier)
        c.register(WeatherAdditionalInfoCell.self, forCellWithReuseIdentifier: WeatherAdditionalInfoCell.reuseIdentifier)
        c.dataSource = self
        return c
    }()

    // MARK: - Init/Deinit
    init(presenter: WeatherPresentable) {
        self.presenter = presenter
        self.style = Style()
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
        presenter.updateLocationIfRequired()
    }
}

// MARK: - Layout
extension WeatherViewController {
    private func setupLayout() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.Named.appTheme
        navigationItem.standardAppearance = appearance

        showBarItems()
        view.backgroundColor = Colors.Named.appTheme

        collectionView.fill(in: view)
    }
}

// MARK: - Actions
extension WeatherViewController {
    @objc private func unitTapped() {
        presenter.togglePreferredUnits()
    }

    @objc private func searchTapped() {
        presenter.navigateToSearch()
    }

    @objc private func locationTapped() {
        presenter.updateLocation()
    }
}

// MARK: - Helpers
extension WeatherViewController {
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

    private func showError(with info: WeatherErrorView.ErrorInfo) {
        removeError()
        let errorView = WeatherErrorView()
        errorView.configure(with: info)
        errorView.fill(in: view)
        self.errorView = errorView
    }

    private func removeError() {
        errorView?.removeFromSuperview()
    }

    private func showContent() {
        collectionView.isHidden = false
        showBarItems()
    }

    private func hideContent() {
        collectionView.isHidden = true
        hideBarItems()
    }

    private func showBarItems() {
        navigationItem.leftBarButtonItem = unitsBarItem
        navigationItem.rightBarButtonItems = [locationBarItem, searchBarItem]
        unitsBarItem.title = presenter.unitSymbol()
    }

    private func hideBarItems() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItems = nil
    }
}

// MARK: WeatherViewable
extension WeatherViewController: WeatherViewable {
    func renderLoading() {
        removeError()
        hideContent()
        showLoading()
    }

    func renderError(with info: WeatherErrorView.ErrorInfo) {
        removeLoading()
        hideContent()
        showError(with: info)
    }

    func renderContent() {
        removeError()
        removeLoading()
        
        showContent()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = presenter.section(atIndex: indexPath.item) else {
            // Will never arrive here, added the case for making the flow exhaustive
            fatalError("Unable to dequeue cell at index: \(indexPath.item)")
        }
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: section.cellIdentifier(),
            for: indexPath
        )
        section.configure(cell: cell)
        return cell
    }
}

// MARK: - Style
extension WeatherViewController {
    private struct Style {
        let interItemSpacing: CGFloat = 5
        let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
    }
}
