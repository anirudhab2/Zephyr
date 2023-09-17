//
//  WeatherErrorCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class WeatherErrorCell: UICollectionViewCell {
    private let style = Style()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = Colors.Text.primary
        l.font = .systemFont(ofSize: style.title)
        return l
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.textColor = Colors.Text.secondary
        l.font = .systemFont(ofSize: style.message)
        l.numberOfLines = 0
        return l
    }()

    private lazy var contentStack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = style.contentSpacing
        return s
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
        contentStack.fill(in: contentView, with: style.contentInsets)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
    }
}

// MARK: - Configuration
extension WeatherErrorCell {
    func configure(with model: WeatherErrorPresentable) {
        titleLabel.text = model.title
        messageLabel.text = model.message
    }
}

// MARK: - Style
extension WeatherErrorCell {
    private struct Style {
        let title: CGFloat = 16
        let message: CGFloat = 12
        let contentSpacing: CGFloat = 5
        let contentInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - WeatherErrorCell + ReusableView
extension WeatherErrorCell: ReusableView { }
