//
//  WeatherBuilder.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import UIKit

struct WeatherBuilder {
    func build(
        locationManager: LocationManager,
        preferences: Preferences
    ) -> UIViewController {
        let interactor = WeatherInteractor()
        let router = WeatherRouter()
        let presenter = WeatherPresenter(
            locationManager: locationManager,
            preferences: preferences,
            interactor: interactor,
            router: router
        )
        let viewController  = WeatherViewController(presenter: presenter)
        presenter.view = viewController
        interactor.listener = presenter
        router.listener = presenter
        router.viewController = viewController
        return viewController
    }
}
