//
//  WeatherAdditionalInfoCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class WeatherAdditionalInfoCell: UICollectionViewCell {
    private let style = Style()

    private lazy var icon: UIImageView = {
        let i = UIImageView()
        i.contentMode = .scaleAspectFit
        i.tintColor = Colors.Text.primary
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: style.fontSize)
        l.textColor = Colors.Text.primary
        l.textAlignment = .left
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        l.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private lazy var valueLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: style.fontSize)
        l.textColor = Colors.Text.primary
        l.textAlignment = .right
        l.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        l.translatesAutoresizingMaskIntoConstraints = false
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
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10

        let backgroundView = UIView()
        backgroundView.backgroundColor = Colors.Named.black.withAlphaComponent(0.2)
        backgroundView.fill(in: contentView)

        contentView.addSubview(icon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: style.contentInsets.top),
            icon.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -style.contentInsets.bottom),
            icon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: style.contentInsets.left),
            icon.widthAnchor.constraint(equalToConstant: style.iconSize.width),
            icon.heightAnchor.constraint(equalToConstant: style.iconSize.height),

            titleLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: style.itemSpacing),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: valueLabel.leftAnchor, constant: -style.itemSpacing),

            valueLabel.centerYAnchor.constraint(equalTo: icon.centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -style.contentInsets.right)
        ])
    }
}

// MARK: - Configuration
extension WeatherAdditionalInfoCell {
    func configure(with model: WeatherAdditionalInfoPresentable) {
        icon.image = model.icon
        titleLabel.text = model.name
        valueLabel.text = model.value
    }
}

// MARK: - Style
extension WeatherAdditionalInfoCell {
    private struct Style {
        let iconSize = CGSize(width: 30, height: 30)
        let fontSize: CGFloat = 20
        let itemSpacing: CGFloat = 10
        let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

// MARK: - WeatherAdditionalInfoCell + ReusableView
extension WeatherAdditionalInfoCell: ReusableView {}
