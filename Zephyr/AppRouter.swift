//
//  AppRouter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

struct AppRouter {
    func setupInitialNavigation(from window: UIWindow) {
        let homeViewController = WeatherBuilder().build(
            locationManager: .init(),
            preferences: Preferences()
        )
        let rootNavigationController = UINavigationController(rootViewController: homeViewController)

        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
    }
}
