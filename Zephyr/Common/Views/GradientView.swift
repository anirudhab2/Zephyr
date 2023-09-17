//
//  GradientView.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 17/09/23.
//

import UIKit

final class GradientView: UIView {
    // MARK: Props
    var style: Style = .vertical {
        didSet {
            guard style != oldValue else {
                return
            }
            apply(style: style)
        }
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        return g
    }()

    // MARK: Init
    convenience init(style: Style) {
        self.init(frame: .zero)
        self.style = style
        apply(style: style)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        self.isUserInteractionEnabled = false
        self.layer.addSublayer(gradientLayer)
        apply(style: style)
    }

    // MARK: Overrides
    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = self.bounds
        apply(style: self.style)
    }
}

// MARK: - Configuration
extension GradientView {
    func apply(style: Style) {
        let startPoint: CGPoint
        let endPoint: CGPoint
        switch style {
            case .horizontal:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)

        case .vertical:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)

        case .custom(let start, let end):
            startPoint = start
            endPoint = end
        }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
    }

    func setColors(_ colors: [UIColor?]) {
        gradientLayer.colors = colors.compactMap({ $0?.cgColor })
        gradientLayer.locations = nil
    }

    func setGradientPoints(_ points: [GradientPoint]) {
        // So that the colors and locations don't have mismatched count
        let colors = points.map { $0.color.cgColor }
        let locations = points.map { NSNumber(value: $0.location) }
        gradientLayer.colors = colors
        gradientLayer.locations = locations
    }
}

// MARK: - Supporting Types
extension GradientView {
    enum Style: Equatable {
        case horizontal
        case vertical
        case custom(start: CGPoint, end: CGPoint)
    }

    struct GradientPoint {
        let color: UIColor
        let location: Double
    }
}
