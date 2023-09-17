//
//  WeatherInteractor.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import Foundation

// MARK: - WeatherInteractable
protocol WeatherInteractable {
    func fetchWeather(
        for location: Location,
        units: Units
    )
}

// MARK: - WeatherInteractorListener
protocol WeatherInteractorListener: AnyObject {
    func fetchedWeatherData(_ data: WeatherInformation)
    func failedToFetchWeather(with error: HttpError)
}

// MARK: - WeatherInteractor
final class WeatherInteractor {
    weak var listener: WeatherInteractorListener?
    private let client = GenericHttpClient()
}

// MARK: WeatherInteractable
extension WeatherInteractor: WeatherInteractable {
    func fetchWeather(
        for location: Location,
        units: Units
    ) {
        let query = location.asQueryParams().merging(units.asQueryParams()) { _, current in current }
        let request = GenericHttpRequest(
            path: Constants.Networking.Paths.weatherData,
            queryParams: query
        )
        client.perform(request: request, decodeAs: WeatherResponse.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                let weatherInfo = WeatherInformation(response: response)
                self.listener?.fetchedWeatherData(weatherInfo)
            case .failure(let error):
                self.listener?.failedToFetchWeather(with: error)
            }
        }
    }
}
