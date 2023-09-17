//
//  WeatherPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//  
//

import Foundation

// MARK: - WeatherPresentable
protocol WeatherPresentable {
    func updateLocation()
    func navigateToSearch()
    func numberOfItems() -> Int
    func section(atIndex index: Int) -> WeatherInfoCellPresenter?
    func handleSelection(atIndex index: Int)
}

// MARK: - WeatherPresenter
final class WeatherPresenter {

    // MARK: TypeAliases
    private typealias LocationModel = RemoteModel<Location, LocationManager.LocationError>
    private typealias WeatherModel = RemoteModel<WeatherInformation, HttpError>

    // MARK: Props
    weak var view: WeatherViewable?

    private let locationManager: LocationManager
    private let interactor: WeatherInteractable
    private let router: WeatherRoutable
    private var units: Units = .metric

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
            view?.refreshContent()
        }
    }

    // MARK: Init/Deinit
    init(
        locationManager: LocationManager,
        interactor: WeatherInteractable,
        router: WeatherRoutable
    ) {
        self.locationManager = locationManager
        self.interactor = interactor
        self.router = router
        self.location = .notFetched
        self.weatherInfo = .notFetched

        sections = [
            WeatherSummaryPresenter.placeholder(),
            WeatherErrorPresenter(error: .locationError(.permissionNotGranted))
        ]
    }
}

// MARK: - States
extension WeatherPresenter {
    private func locationUpdated(to location: LocationModel) {
        switch location {
        case .notFetched:
            sections = [
                WeatherSummaryPresenter.placeholder(),
                WeatherErrorPresenter(error: .locationError(.permissionNotGranted))
            ]

        case .fetching:
            sections = [
                WeatherSummaryPresenter.placeholder()
            ]

        case .fetched(let location):
            weatherInfo = .fetching
            interactor.fetchWeather(for: location, units: units)

        case .failed(let error):
            sections = [
                WeatherSummaryPresenter.placeholder(),
                WeatherErrorPresenter(error: .locationError(error))
            ]
        }
    }

    private func weatherDataUpdate(to weatherInfo: WeatherModel) {
        switch weatherInfo {
        case .notFetched:
            break

        case .fetching:
            sections = [
                WeatherSummaryPresenter.placeholder()
            ]

        case .fetched(let info):
            sections = createSections(with: info, units: units)

        case .failed(let error):
            sections = [
                WeatherSummaryPresenter.placeholder(),
                WeatherErrorPresenter(error: .weatherDataError(error))
            ]
        }
    }
}

// MARK: - Helpers
extension WeatherPresenter {
    private func createSections(
        with weatherInfo: WeatherInformation,
        units: Units
    ) -> [WeatherInfoCellPresenter] {
        var sections: [WeatherInfoCellPresenter?] = [
            WeatherSummaryPresenter(
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

    func numberOfItems() -> Int {
        sections.count
    }

    func section(atIndex index: Int) -> WeatherInfoCellPresenter? {
        guard sections.indices.contains(index) else { return nil }
        return sections[index]
    }

    func handleSelection(atIndex index: Int) {
        
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
