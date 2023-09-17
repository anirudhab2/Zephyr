//
//  Logger.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import Foundation

enum Logger: String {
    case debug
    case error
}

extension Logger {
    enum Category: String {
        case networking
        case location
    }
}

extension Logger {
    func log(
        message: @autoclosure @escaping () -> CustomStringConvertible,
        category: Category
    ) {
        DispatchQueue.global(qos: .utility).async {
            let tags = [self.rawValue, category.rawValue].map({ "[\($0.uppercased())]" }).joined()
            let fullMessage = tags + message().description
            print(fullMessage)
        }
    }
}
