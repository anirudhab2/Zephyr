//
//  SearchResultCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class SearchResultCell: UITableViewCell {

    private let style = Style()

    var text: String? {
        get {
            titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: style.titleFontSize)
        l.textColor = Colors.Named.white
        l.numberOfLines = 2
        return l
    }()

    // MARK: Init/Deinit
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        titleLabel.fill(in: contentView, with: style.contentInsets)
    }
}

// MARK: - Style
extension SearchResultCell {
    private struct Style {
        let titleFontSize: CGFloat = 16
        let contentInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

// MARK: - ReusableView
extension SearchResultCell: ReusableView {}
