//
//  WeatherPrimaryInfoPresenter.swift
//  Zephyr
//
//  Created by Anirudha Tolambia on 16/09/23.
//

import UIKit

protocol WeatherPrimaryInfoPresentable {
    var temperature: String { get }
    var weatherIcon: UIImage? { get }
    var summary: String? { get }
}

struct WeatherPrimaryInfoPresenter: WeatherPrimaryInfoPresentable {
    let temperature: String
    let weatherIcon: UIImage?
    let summary: String?

    init(
        temperature: String,
        weatherIcon: UIImage? = nil,
        summary: String? = nil
    ) {
        self.temperature = temperature
        self.weatherIcon = weatherIcon
        self.summary = summary
    }

    init(
        weatherInfo: WeatherInformation,
        units: Units
    ) {
        weatherIcon = {
            guard let iconCode = weatherInfo.weather.displayInfo?.icon,
                  let type = WeatherType(iconCode: iconCode) else {
                return Assets.Clouds.full
            }
            return type.asset()
        }()

        let formatter = Formatters.temperature
        let tempInfo = weatherInfo.weather.temperature
        temperature = formatter.format(tempInfo.current, unit: units) ?? "--"

        let location = weatherInfo.location.cityName
        let conditions = weatherInfo.weather.displayInfo?.conditions
        let temperatureRange: String? = {
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

        summary = [location, conditions, temperatureRange].compactMap({ $0 }).joined(separator: " | ")
    }
}

// MARK: - WeatherSummaryPresenter + WeatherInfoCellPresenter
extension WeatherPrimaryInfoPresenter: WeatherInfoCellPresenter {
    func cellIdentifier() -> String {
        WeatherPrimaryInfoCell.reuseIdentifier
    }

    func configure(cell: UICollectionViewCell) {
        guard let cell = cell as? WeatherPrimaryInfoCell else { return }
        cell.configure(with: self)
    }
}

// MARK: - Factory
extension WeatherPrimaryInfoPresenter {
    static func placeholder() -> Self {
        .init(temperature: "--")
    }
}
