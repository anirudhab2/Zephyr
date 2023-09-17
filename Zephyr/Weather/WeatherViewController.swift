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
    func refreshContent()
}

// MARK: - WeatherViewController
final class WeatherViewController: UIViewController {

    private let presenter: WeatherPresentable
    private let style: Style

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
        c.register(WeatherSummaryCell.self, forCellWithReuseIdentifier: WeatherSummaryCell.reuseIdentifier)
        c.register(WeatherErrorCell.self, forCellWithReuseIdentifier: WeatherErrorCell.reuseIdentifier)
        c.register(WeatherAdditionalInfoCell.self, forCellWithReuseIdentifier: WeatherAdditionalInfoCell.reuseIdentifier)
        c.dataSource = self
        c.delegate = self
        return c
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
        presenter.updateLocation()
    }
}

// MARK: - Layout
extension WeatherViewController {
    private func setupLayout() {
        self.navigationItem.rightBarButtonItems = [searchBarItem, locationBarItem]

        let gradientView = GradientView(style: .vertical)
        gradientView.setColors([Colors.Named.blue, Colors.Named.black])
        gradientView.fill(in: view)

        collectionView.fill(in: view)
    }
}

// MARK: - Actions
extension WeatherViewController {
    @objc private func searchTapped() {
        presenter.navigateToSearch()
    }

    @objc private func locationTapped() {
        presenter.updateLocation()
    }
}

// MARK: WeatherViewable
extension WeatherViewController: WeatherViewable {
    func refreshContent() {
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

// MARK: - UICollectionViewDelegate
extension WeatherViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.handleSelection(atIndex: indexPath.item)
    }
}

// MARK: - Style
extension WeatherViewController {
    private struct Style {
        let interItemSpacing: CGFloat = 5
        let contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
    }
}
