//
//  UIView+Additions.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

extension UIView {
    func fill(in container: UIView, with insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: container.leftAnchor, constant: insets.left),
            self.rightAnchor.constraint(equalTo: container.rightAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: container.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -insets.bottom)
        ])
    }
}
