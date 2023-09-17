//
//  WeatherErrorView.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class WeatherErrorView: UIView {

    private let style = Style()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = style.titleFont
        l.textColor = Colors.Named.white
        l.textAlignment = .center
        return l
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.font = style.messageFont
        l.textColor = Colors.Named.secondaryWhite
        l.textAlignment = .center
        l.numberOfLines = 3
        return l
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = style.contentSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(contentStack)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            contentStack.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: style.contentInsets.left),
            contentStack.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -style.contentInsets.right),
            contentStack.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: style.contentInsets.top),
            contentStack.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -style.contentInsets.bottom)
        ])
    }

    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }

    func configureAction(title: String, action: @escaping () -> Void) {
        let button = ActionButton(type: .custom)
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.Named.white.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = Colors.Named.white
        button.titleLabel?.font = style.actionFont
        button.configure(title: title, tapAction: action)
        contentStack.addArrangedSubview(button)
    }

    func configure(with errorInfo: ErrorInfo) {
        configure(title: errorInfo.title, message: errorInfo.message)
        configureAction(title: errorInfo.actionTitle, action: errorInfo.action)
    }

    func removeAllActions() {
        contentStack.arrangedSubviews.forEach({ ($0 as? ActionButton)?.removeFromSuperview() })
    }
}

// MARK: - ErrorInfo
extension WeatherErrorView {
    struct ErrorInfo {
        let title: String
        let message: String
        let actionTitle: String
        let action: () -> Void
    }
}

// MARK: - Style
extension WeatherErrorView {
    private struct Style {
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
        let messageFont = UIFont.systemFont(ofSize: 16)
        let actionFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let contentSpacing: CGFloat = 20
        let contentInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
}

// MARK: - Action Button
extension WeatherErrorView {
    private final class ActionButton: UIButton {
        typealias Action = () -> Void

        private var tapAction: Action?

        func configure(title: String, tapAction: @escaping Action) {
            setTitle(title, for: .normal)
            self.tapAction = tapAction
            addTarget(self, action: #selector(tapped), for: .touchUpInside)
        }

        @objc private func tapped() {
            tapAction?()
        }
    }
}
