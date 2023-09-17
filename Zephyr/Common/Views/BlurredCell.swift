//
//  BlurredCell.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

class BlurredCell: UICollectionViewCell {
    private lazy var blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blur)
        return view
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
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5
        blurView.fill(in: contentView)
    }
}
