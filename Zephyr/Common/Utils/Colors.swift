//
//  Colors.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

enum Colors {
    enum Named {
        static var blue: UIColor {
            .systemBlue
        }

        static var black: UIColor {
            .black
        }
    }
}

extension Colors {
    enum Background {
        static var primary: UIColor {
            .systemBackground
        }
    }

    enum Text {
        static var primary: UIColor {
            .white
        }

        static var secondary: UIColor {
            primary.withAlphaComponent(0.7)
        }
    }
}
