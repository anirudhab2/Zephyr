//
//  WetherErrorPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

protocol WeatherErrorPresentable {
    var title: String { get }
    var message: String { get }
}

struct WeatherErrorPresenter: WeatherErrorPresentable {
    let title: String
    let message: String

    init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    init(error: WeatherError) {
        switch error {
        case .locationError(let locationError):
            self.init(locationError: locationError)

        case .weatherDataError(let httpError):
            self.init(httpError: httpError)
        }
    }

    private init(locationError: LocationManager.LocationError) {
        switch locationError {
        case .permissionNotGranted:
            title = "No location found"
            message = "Search for location or enable location permission to see the weather data for your location"

        case .failed, .locationAccessRestricted:
            title = "No location found"
            message = "Unable to determine your location, search your location to see the latest weather data"
        }
    }

    private init(httpError: HttpError) {
        switch httpError {
        case .requestFailed:
            title = "Unable to connect"
            message = "Please check your internet connection and try again"

        case .invalidData, .responseFailure:
            title = "Unable to fetch weather data"
            message = "Soemthing went wrong, please retry"

        case .invalidRequest, .decodingFailure:
            title = "Something went wrong"
            message = "Tap here to share logs with the developer"
        }
    }
}

extension WeatherErrorPresenter {
    enum WeatherError: Error {
        case locationError(LocationManager.LocationError)
        case weatherDataError(HttpError)
    }
}

extension WeatherErrorPresenter: WeatherInfoCellPresenter {
    func cellIdentifier() -> String {
        WeatherErrorCell.reuseIdentifier
    }

    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? WeatherErrorCell else { return }
        cell.configure(with: self)
    }
}
