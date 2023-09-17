//
//  WeatherSummaryCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

final class WeatherSummaryCell: BlurredCell {
    // MARK: Props
    private let style = Style()

    private lazy var locationLabel = makeLabel(withFontSize: style.location)
    private lazy var temperatureLabel = makeLabel(withFontSize: style.temperature, weight: .light)
    private lazy var conditionsLabel = makeLabel(withFontSize: style.conditions, alignment: .center)
    private lazy var temperatureRangeLabel = makeLabel(withFontSize: style.temperatureRange)

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
        let firstColumn: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = style.contentSpacing
            return stack
        }()
        firstColumn.addArrangedSubview(locationLabel)
        firstColumn.addArrangedSubview(temperatureLabel)
        firstColumn.addArrangedSubview(temperatureRangeLabel)

        let secondColumn: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = style.contentSpacing
            return stack
        }()
        secondColumn.addArrangedSubview(weatherIcon)
        secondColumn.addArrangedSubview(conditionsLabel)

        let contentStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = style.contentSpacing
            return stack
        }()

        contentStack.addArrangedSubview(firstColumn)
        contentStack.addArrangedSubview(secondColumn)

        contentStack.fill(in: contentView, with: style.contentInsets)
    }
}

// MARK: - Configuration
extension WeatherSummaryCell {
    func configure(with model: WeatherSummaryPresentable) {
        locationLabel.text = model.location
        temperatureLabel.text = model.temperature
        conditionsLabel.text = model.conditions
        temperatureRangeLabel.text = model.temperatureRange
        weatherIcon.image = model.weatherIcon
    }
}

// MARK: - Factories
extension WeatherSummaryCell {
    private func makeLabel(
        withFontSize size: CGFloat,
        weight: UIFont.Weight = .regular,
        alignment: NSTextAlignment = .left
    ) -> UILabel {
        let l = UILabel()
        l.font = .systemFont(ofSize: size, weight: weight)
        l.textColor = Colors.Text.primary
        l.textAlignment = alignment
        return l
    }
}

// MARK: - Style
extension WeatherSummaryCell {
    private struct Style {
        let location: CGFloat = 24
        let temperature: CGFloat = 80
        let conditions: CGFloat = 16
        let temperatureRange: CGFloat = 16
        let contentSpacing: CGFloat = 10
        let iconSize = CGSize(width: 80, height: 80)
        let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

// MARK: - WeatherSummaryCell + ReusableView
extension WeatherSummaryCell: ReusableView { }
