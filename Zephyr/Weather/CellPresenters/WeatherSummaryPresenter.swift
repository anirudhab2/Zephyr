//
//  WeatherSummaryPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

protocol WeatherSummaryPresentable {
    var location: String? { get }
    var temperature: String { get }
    var conditions: String? { get }
    var temperatureRange: String? { get }
    var weatherIcon: UIImage? { get }
}

struct WeatherSummaryPresenter: WeatherSummaryPresentable {
    let location: String?
    let temperature: String
    let conditions: String?
    let temperatureRange: String?
    let weatherIcon: UIImage?

    init(
        location: String? = nil,
        temperature: String,
        conditions: String? = nil,
        temperatureRange: String? = nil,
        weatherIcon: UIImage? = nil
    ) {
        self.location = location
        self.temperature = temperature
        self.conditions = conditions
        self.temperatureRange = temperatureRange
        self.weatherIcon = weatherIcon
    }

    init(
        weatherInfo: WeatherInformation,
        units: Units
    ) {
        location = weatherInfo.location.cityName
        conditions = weatherInfo.weather.displayInfo?.conditions

        let formatter = Formatters.temperature
        let tempInfo = weatherInfo.weather.temperature
        temperature = formatter.format(tempInfo.current, unit: units) ?? "--"
        temperatureRange = {
            guard let min = tempInfo.min,
                  let max = tempInfo.max,
                  max > min else {
                return nil
            }
            guard let minTemp = formatter.format(min, unit: units),
                  let maxTemp = formatter.format(max, unit: units) else {
                return nil
            }
            return "L:\(minTemp) - H:\(maxTemp)"
        }()

        weatherIcon = {
            guard let iconCode = weatherInfo.weather.displayInfo?.icon,
                  let type = WeatherType(iconCode: iconCode) else {
                return Assets.Clouds.full
            }
            return type.asset()
        }()
    }
}

// MARK: - WeatherSummaryPresenter + WeatherInfoCellPresenter
extension WeatherSummaryPresenter: WeatherInfoCellPresenter {
    func cellIdentifier() -> String {
        WeatherSummaryCell.reuseIdentifier
    }

    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? WeatherSummaryCell else { return }
        cell.configure(with: self)
    }
}

// MARK: - Factory
extension WeatherSummaryPresenter {
    static func placeholder() -> Self {
        .init(temperature: "--")
    }
}
