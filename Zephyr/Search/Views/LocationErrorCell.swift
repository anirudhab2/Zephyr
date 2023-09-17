//
//  LocationErrorCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class LocationErrorCell: UITableViewCell {

    private let style = Style()

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = style.titleFont
        l.textAlignment = .center
        return l
    }()

    private lazy var messageLabel: UILabel = {
        let l = UILabel()
        l.font = style.messageFont
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = style.contentSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        contentStack.fill(in: contentView, with: style.contentInsets)
    }
}

extension LocationErrorCell {
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }

    func configure(with locationError: LocationManager.LocationError) {
        let message = "Search for locations or enable permissions to track your location, so you can get the latest weather information"
        switch locationError {
        case .failed, .locationAccessRestricted:
            configure(title: "No locations found", message: message)

        case .permissionNotGranted:
            configure(title: "Location permission not granted", message: message)
        }
    }
}

extension LocationErrorCell {
    private struct Style {
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        let messageFont = UIFont.systemFont(ofSize: 16)
        let contentSpacing: CGFloat = 5
        let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}
