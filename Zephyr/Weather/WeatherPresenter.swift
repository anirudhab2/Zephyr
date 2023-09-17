//
//  WeatherPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import UIKit

// MARK: - WeatherPresentable
protocol WeatherPresentable {
    func updateLocationIfRequired()
    func updateLocation()
    func navigateToSearch()
    func togglePreferredUnits()
    func unitSymbol() -> String
    func numberOfItems() -> Int
    func section(atIndex index: Int) -> WeatherInfoCellPresenter?
}

// MARK: - WeatherPresenter
final class WeatherPresenter {

    // MARK: TypeAliases
    private typealias LocationModel = RemoteModel<Location, LocationManager.LocationError>
    private typealias WeatherModel = RemoteModel<WeatherInformation, HttpError>

    // MARK: Props
    weak var view: WeatherViewable?

    private let locationManager: LocationManager
    private let preferences: Preferences
    private let interactor: WeatherInteractable
    private let router: WeatherRoutable
    private var units: Units {
        didSet {
            preferences.units = units
            refreshWeatherData()
        }
    }

    private var location: LocationModel {
        didSet {
            locationUpdated(to: location)
        }
    }

    private var weatherInfo: WeatherModel {
        didSet {
            weatherDataUpdate(to: weatherInfo)
        }
    }

    private var sections: [WeatherInfoCellPresenter] {
        didSet {
            view?.renderContent()
        }
    }

    // MARK: Init/Deinit
    init(
        locationManager: LocationManager,
        preferences: Preferences,
        interactor: WeatherInteractable,
        router: WeatherRoutable
    ) {
        self.locationManager = locationManager
        self.preferences = preferences
        self.interactor = interactor
        self.router = router
        self.units = preferences.units

        self.location = {
            if let location = preferences.location {
                return .fetched(location)
            }
            return .notFetched
        }()
        self.weatherInfo = .notFetched
        self.sections = []

        locationUpdated(to: location)
    }
}

// MARK: - States
extension WeatherPresenter {
    private func locationUpdated(to location: LocationModel) {
        switch location {
        case .notFetched:
            view?.renderLoading()

        case .fetching:
            view?.renderLoading()

        case .fetched(let location):
            preferences.location = location
            refreshWeatherData()
            view?.renderLoading()

        case .failed(let error):
            let title: String
            let message: String
            switch error {
            case .permissionNotGranted:
                title = "No location found"
                message = "Search for location or enable location permission to see the weather data for your location"

            case .failed, .locationAccessRestricted:
                title = "No location found"
                message = "Unable to determine your location, search your location to see the latest weather data"
            }
            let errorInfo = WeatherErrorView.ErrorInfo(
                title: title,
                message: message,
                actionTitle: "Settings",
                action: {
                    let settingsURL = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(settingsURL)
                }
            )
            view?.renderError(with: errorInfo)
        }
    }

    private func weatherDataUpdate(to weatherInfo: WeatherModel) {
        switch weatherInfo {
        case .notFetched:
            break

        case .fetching:
            view?.renderLoading()

        case .fetched(let info):
            sections = createSections(with: info, units: units)

        case .failed:
            let errorInfo = WeatherErrorView.ErrorInfo(
                title: "Something went wrong",
                message: "Unable to fetch weather data at your location",
                actionTitle: "Retry",
                action: { [weak self] in
                    self?.refreshWeatherData()
                }
            )
            view?.renderError(with: errorInfo)
        }
    }
}

// MARK: - Helpers
extension WeatherPresenter {
    private func refreshWeatherData() {
        guard case .fetched(let location) = self.location else { return }
        weatherInfo = .fetching
        interactor.fetchWeather(for: location, units: units)
    }

    private func createSections(
        with weatherInfo: WeatherInformation,
        units: Units
    ) -> [WeatherInfoCellPresenter] {
        var sections: [WeatherInfoCellPresenter?] = [
            WeatherPrimaryInfoPresenter(
                weatherInfo: weatherInfo,
                units: units
            ),
            WeatherAdditionalInfoPresenter(
                info: .apparentTemperature(weatherInfo.weather.temperature.feelsLike),
                units: units
            ),
            WeatherAdditionalInfoPresenter(
                info: .humidity(weatherInfo.weather.humidity),
                units: units
            ),
            WeatherAdditionalInfoPresenter(
                info: .pressure(weatherInfo.weather.pressure.current),
                units: units
            ),
            WeatherAdditionalInfoPresenter(
                info: .sunrise(weatherInfo.weather.sun.sunrise),
                units: units
            ),
            WeatherAdditionalInfoPresenter(
                info: .sunset(weatherInfo.weather.sun.sunset),
                units: units
            )
        ]
        if let rain = weatherInfo.weather.rain?.lastHour {
            sections.append(
                WeatherAdditionalInfoPresenter(
                    info: .rain(rain),
                    units: units
                )
            )
        }
        if let snow = weatherInfo.weather.snow?.lastHour {
            sections.append(
                WeatherAdditionalInfoPresenter(
                    info: .snow(snow),
                    units: units
                )
            )
        }
        return sections.compactMap({ $0 })
    }
}

// MARK: WeatherPresentable
extension WeatherPresenter: WeatherPresentable {
    func updateLocationIfRequired() {
        switch location {
        case .notFetched, .failed:
            updateLocation()
        case .fetching, .fetched:
            break
        }
    }

    func updateLocation() {
        location = .fetching
        locationManager.fetchCurrentLocation { [weak self] result in
            switch result {
            case .success(let location):
                self?.location = .fetched(location)

            case .failure(let error):
                self?.location = .failed(error)
            }
        }
    }

    func navigateToSearch() {
        router.navigateToSearch()
    }

    func togglePreferredUnits() {
        units.toggle()
    }

    func unitSymbol() -> String {
        switch units {
        case .metric:
            return "°C"
        case .imperial:
            return "°F"
        }
    }

    func numberOfItems() -> Int {
        sections.count
    }

    func section(atIndex index: Int) -> WeatherInfoCellPresenter? {
        guard sections.indices.contains(index) else { return nil }
        return sections[index]
    }
}

// MARK: WeatherInteractorListener
extension WeatherPresenter: WeatherInteractorListener {
    func fetchedWeatherData(_ data: WeatherInformation) {
        weatherInfo = .fetched(data)
    }

    func failedToFetchWeather(with error: HttpError) {
        weatherInfo = .failed(error)
    }
}

// MARK: WeatherRouterListener
extension WeatherPresenter: WeatherRouterListener {
    func updateLocation(with location: Location) {
        self.location = .fetched(location)
    }
}
