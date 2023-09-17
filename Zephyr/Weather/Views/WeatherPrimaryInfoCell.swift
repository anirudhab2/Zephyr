//
//  WeatherPrimaryInfoCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

final class WeatherPrimaryInfoCell: UICollectionViewCell {
    // MARK: Props
    private let style = Style()

    private lazy var weatherIcon: UIImageView = {
        let i = UIImageView()
        i.tintColor = Colors.Text.primary
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            i.widthAnchor.constraint(equalToConstant: style.iconSize.width),
            i.heightAnchor.constraint(equalToConstant: style.iconSize.height)
        ])
        return i
    }()

    private lazy var temperatureLabel: UILabel = {
        let l = UILabel()
        l.font = style.temperature
        l.textColor = Colors.Named.white
        l.textAlignment = .center
        return l
    }()

    private lazy var summaryLabel: UILabel = {
        let l = UILabel()
        l.font = style.summary
        l.textColor = Colors.Named.secondaryWhite
        l.textAlignment = .center
        l.numberOfLines = 2
        return l
    }()

    // MARK: Init/Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        let contentStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = style.spacingX
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        let firstRow: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = style.spacingY
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        firstRow.addArrangedSubview(weatherIcon)
        firstRow.addArrangedSubview(temperatureLabel)

        contentStack.addArrangedSubview(firstRow)
        contentStack.addArrangedSubview(summaryLabel)

        contentView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: style.contentInsets.top),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -style.contentInsets.bottom),
            contentStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: style.contentInsets.left),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -style.contentInsets.right)
        ])
    }
}

// MARK: - Configuration
extension WeatherPrimaryInfoCell {
    func configure(with model: WeatherPrimaryInfoPresentable) {
        temperatureLabel.text = model.temperature
        weatherIcon.image = model.weatherIcon?.applyingSymbolConfiguration(.init(font: temperatureLabel.font))
        summaryLabel.text = model.summary
    }
}

// MARK: - Style
extension WeatherPrimaryInfoCell {
    private struct Style {
        let temperature = UIFont.systemFont(ofSize: 80, weight: .thin)
        let summary = UIFont.systemFont(ofSize: 16, weight: .regular)
        let iconSize = CGSize(width: 80, height: 80)
        let spacingX: CGFloat = 10
        let spacingY: CGFloat = 20
        let contentInsets = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
    }
}

// MARK: - WeatherSummaryCell + ReusableView
extension WeatherPrimaryInfoCell: ReusableView { }
