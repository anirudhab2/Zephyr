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

        static var white: UIColor {
            .white
        }

        static var secondaryWhite: UIColor {
            white.withAlphaComponent(0.7)
        }

        static var appTheme: UIColor {
            UIColor(red: 255/255, green: 121/255, blue: 105/255, alpha: 1)
        }
    }
}
